module "keypair" {
  source  = "git@github.com:bluesentry/tf-module.keypair.git?ref=v2.0.4"
  name    = "evolven"
}

resource "aws_kms_key" "eks" {
  description = "${local.kubernetes_cluster_name} EKS Cluster Secret Encryption Key"
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"
version = "19.10.0"

  cluster_name                          = local.kubernetes_cluster_name
  cluster_version                       = var.kubernetes_cluster_version
  subnets                               = local.kubernetes_subnet_ids
  vpc_id                                = local.kubernetes_vpc_id
  enable_irsa                           = var.kubernetes_enable_irsa
  cluster_endpoint_private_access       = var.kubernetes_cluster_endpoint_private_access
  cluster_endpoint_private_access_cidrs = local.kubernetes_cluster_endpoint_private_access_cidrs
  cluster_endpoint_public_access        = var.kubernetes_cluster_endpoint_public_access
  cluster_endpoint_public_access_cidrs  = local.kubernetes_cluster_endpoint_public_access_cidrs

  manage_aws_auth = var.kubernetes_manage_aws_auth
  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.eks.arn
      resources        = ["secrets"]
    }
  ]

  node_groups_defaults = {
    ami_type      = "AL2_x86_64"
    disk_size     = var.kubernetes_root_volume_size
    capacity_type = "ON_DEMAND"
    subnets = module.vpc.0.public_subnets
    key_name = module.keypair.key_name

    tags = [
      {
        key                 = "k8s.io/cluster-autoscaler/enabled"
        propagate_at_launch = "false"
        value               = "true"
      },
      {
        key                 = "k8s.io/cluster-autoscaler/${local.kubernetes_cluster_name}"
        propagate_at_launch = "false"
        value               = "true"
      }
    ]
  }

  node_groups = {
    application = {
      name             = "application"
      desired_capacity = var.kubernetes_application_nodes_instance_desired_capacity
      min_capacity     = var.kubernetes_application_nodes_instance_min_capacity
      max_capacity     = var.kubernetes_application_nodes_instance_max_capacity

      instance_types  = [var.kubernetes_system_nodes_instance_type]
      capacity_type   = "SPOT"
      additional_tags = var.tags
    }
    system = {
      name             = "system"
      desired_capacity = var.kubernetes_system_nodes_instance_desired_capacity
      min_capacity     = var.kubernetes_system_nodes_instance_min_capacity
      max_capacity     = var.kubernetes_system_nodes_instance_max_capacity

      instance_types  = [var.kubernetes_system_nodes_instance_type]
      additional_tags = var.tags
    }
  }

  map_users = [
    {
      userarn  = "arn:aws:iam::222771205538:user/Oran"
      username = "Oran"
      groups   = ["system:masters"]
    },
  ]

  tags = var.tags
}

data "kubernetes_secret" "evolven_collection" {
  metadata {
    name = kubernetes_service_account.evolven_collection.default_secret_name
    namespace = "kube-system"
  }
}

resource "kubernetes_service_account" "evolven_collection" {
  metadata {
    name = "evolven-collection"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role" "evolven_collection" {
  metadata {
    name = "evolven-collection"
  }
  rule {
    api_groups = [""]
    verbs = [
      "get",
      "list",
      "watch",
    ]
    resources = [
      "nodes",
      "secrets",
    ]
  }
}

resource "kubernetes_cluster_role_binding" "evolven_collection_view" {
  metadata {
    name = "evolven-collection-view"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }
  subject {
    kind      = "ServiceAccount"
    name = "evolven-collection"
    namespace = "kube-system"
    //    name      = kubernetes_service_account.evolven_collection.metadata["name"]
    //    namespace = kubernetes_service_account.evolven_collection.metadata["namespace"]
  }
}

resource "kubernetes_cluster_role_binding" "evolven_collection" {
  metadata {
    name = "evolven-collection"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.evolven_collection.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name = "evolven-collection"
    namespace = "kube-system"
    //    name      = kubernetes_service_account.evolven_collection.metadata["name"]
    //    namespace = kubernetes_service_account.evolven_collection.metadata["namespace"]
  }
}

module "iam_cluster_autoscaler" {
  count  = var.cluster_autoscaler_enabled ? 1 : 0
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"

  version                       = "~> v3.4.0"
  create_role                   = true
  role_name                     = "${local.kubernetes_cluster_name}-k8s-cluster-autoscaler"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.cluster_autoscaler.0.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:cluster-autoscaler"]
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  count = var.cluster_autoscaler_enabled ? 1 : 0

  policy_arn = aws_iam_policy.cluster_autoscaler.0.arn
  role = module.iam_cluster_autoscaler.0.this_iam_role_name
}

resource "aws_iam_policy" "cluster_autoscaler" {
  count = var.cluster_autoscaler_enabled ? 1 : 0

  name        = "${local.kubernetes_cluster_name}-k8s-cluster-autoscaler"
  description = "Cluster Autoscaler policy for cluster ${module.eks.cluster_id}"
  policy      = data.aws_iam_policy_document.cluster_autoscaler.0.json
}

data "aws_iam_policy_document" "cluster_autoscaler" {
  count = var.cluster_autoscaler_enabled ? 1 : 0

  statement {
    sid    = "clusterAutoscalerAll"
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "ec2:DescribeLaunchTemplateVersions",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "clusterAutoscalerOwn"
    effect = "Allow"

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/kubernetes.io/cluster/${module.eks.cluster_id}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
      values   = ["true"]
    }
  }
}

module "iam_velero" {
  count  = var.velero_enabled ? 1 : 0
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"

  version                       = "~> v3.4.0"
  create_role                   = true
  role_name                     = "${local.kubernetes_cluster_name}-k8s-velero"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.velero.0.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:velero:velero"]
}

resource "aws_iam_policy" "velero" {
  count = var.velero_enabled ? 1 : 0

  name        = "${local.kubernetes_cluster_name}-k8s-velero"
  description = "Velero policy for cluster ${module.eks.cluster_id}"
  policy      = data.aws_iam_policy_document.velero.0.json
}

data "aws_iam_policy_document" "velero" {
  count = var.velero_enabled ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DeleteSnapshot",
      "ec2:DescribeSnapshots",
      "ec2:DescribeVolumes",
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
    ]

    resources = ["${module.s3_backup_bucket.0.this_s3_bucket_arn}/*"]
  }

  statement {
    effect = "Allow"

    actions = ["s3:ListBucket"]

    resources = [module.s3_backup_bucket.0.this_s3_bucket_arn]
  }
}

resource "helm_release" "argocd" {
  count = var.argocd_enabled ? 1 : 0

  name = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart = "argo-cd"
  version = "latest"
  namespace = "argocd"
  create_namespace = true

  values = [
    file("${path.module}/values-argo-cd.yaml"),
    var.argocd_values,
  ]
}

resource "helm_release" "cluster_autoscaler" {
  count = var.cluster_autoscaler_enabled ? 1 : 0

  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = "latest"
  namespace  = "kube-system"
  values = [
    templatefile("${path.module}/values-cluster-autoscaler.yaml.tmpl",
      {
        AWS_REGION   = data.aws_region.current.name,
        CLUSTER_NAME = module.eks.cluster_id,
        IMAGE_TAG    = "v1.19.1",
        ROLE_ARN     = module.iam_cluster_autoscaler.0.this_iam_role_arn
      }
    ),
    var.cluster_autoscaler_values,
  ]
}

resource "helm_release" "ingress_nginx" {
  count = var.ingress_nginx_enabled ? 1 : 0

  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "latest"
  namespace        = var.ingress_nginx_namespace
  create_namespace = true

  values = [
    file("${path.module}/values-ingress-nginx.yaml"),
    var.ingress_nginx_values,
  ]
}

resource "helm_release" "sock_shop" {
  count = var.sock_shop_enabled ? 1 : 0

  name             = "sock-shop"
  chart            = "${path.module}/charts/sock-shop"
  namespace = "sock-shop"
  create_namespace = true
  values = [var.sock_shop_values]
}

resource "helm_release" "metrics_server" {
  name = "metrics-server"
  repository = "https://charts.bitnami.com/bitnami"
  chart = "metrics-server"
  namespace = "kube-system"
  version = "latest"
  values = [file("${path.module}/values-metrics-server.yaml")]
}
