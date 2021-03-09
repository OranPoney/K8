data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_region" "current" {}

data "aws_subnet" "kubernetes" {
  count = length(local.kubernetes_subnet_ids)

  id = local.kubernetes_subnet_ids[count.index]
}

data "aws_vpc" "kubernetes" {
  id = data.aws_subnet.kubernetes.0.vpc_id
}
