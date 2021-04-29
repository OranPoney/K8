module "vpc" {
  count = var.vpc_create ? 1 : 0

  source  = "terraform-aws-modules/vpc/aws"
version = "2.64.0"

  name                         = local.vpc_name
  cidr                         = var.vpc_cidr
  azs                          = local.availability_zones
  database_subnets             = var.vpc_database_subnets
  private_subnets              = var.vpc_private_subnets
  public_subnets               = var.vpc_public_subnets
  enable_nat_gateway           = var.vpc_enable_nat_gateway
  single_nat_gateway           = var.vpc_single_nat_gateway
  enable_dns_hostnames         = var.vpc_enable_dns_hostnames
  enable_dns_support           = var.vpc_enable_dns_support
  create_database_subnet_group = false

  ebs_endpoint_private_dns_enabled             = var.vpc_ebs_endpoint_private_dns_enabled
  ebs_endpoint_security_group_ids              = var.vpc_ebs_endpoint_security_group_ids
  ebs_endpoint_subnet_ids                      = var.vpc_ebs_endpoint_subnet_ids
  ec2_autoscaling_endpoint_private_dns_enabled = var.vpc_ec2_autoscaling_endpoint_private_dns_enabled
  ec2_autoscaling_endpoint_security_group_ids  = var.vpc_ec2_autoscaling_endpoint_security_group_ids
  ec2_autoscaling_endpoint_subnet_ids          = var.vpc_ec2_autoscaling_endpoint_subnet_ids
  ec2_endpoint_private_dns_enabled             = var.vpc_ec2_endpoint_private_dns_enabled
  ec2_endpoint_security_group_ids              = var.vpc_ec2_endpoint_security_group_ids
  ec2_endpoint_subnet_ids                      = var.vpc_ec2_endpoint_subnet_ids
  ecr_api_endpoint_private_dns_enabled         = var.vpc_ecr_api_endpoint_private_dns_enabled
  ecr_api_endpoint_security_group_ids          = var.vpc_ecr_api_endpoint_security_group_ids
  ecr_api_endpoint_subnet_ids                  = var.vpc_ecr_api_endpoint_subnet_ids
  ecr_dkr_endpoint_private_dns_enabled         = var.vpc_ecr_dkr_endpoint_private_dns_enabled
  ecr_dkr_endpoint_security_group_ids          = var.vpc_ecr_dkr_endpoint_security_group_ids
  ecr_dkr_endpoint_subnet_ids                  = var.vpc_ecr_dkr_endpoint_subnet_ids
  enable_ebs_endpoint                          = var.vpc_enable_ebs_endpoint
  enable_ec2_autoscaling_endpoint              = var.vpc_enable_ec2_autoscaling_endpoint
  enable_ec2_endpoint                          = var.vpc_enable_ec2_endpoint
  enable_ecr_api_endpoint                      = var.vpc_enable_ecr_api_endpoint
  enable_ecr_dkr_endpoint                      = var.vpc_enable_ecr_dkr_endpoint
  enable_kms_endpoint                          = var.vpc_enable_kms_endpoint
  enable_s3_endpoint                           = var.vpc_enable_s3_endpoint
  kms_endpoint_private_dns_enabled             = var.vpc_kms_endpoint_private_dns_enabled
  kms_endpoint_security_group_ids              = var.vpc_kms_endpoint_security_group_ids
  kms_endpoint_subnet_ids                      = var.vpc_kms_endpoint_subnet_ids

  tags = var.tags

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.kubernetes_cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"                        = "1"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.kubernetes_cluster_name}" = "shared"
    "kubernetes.io/role/elb"                                 = "1"
  }
}

resource "aws_ec2_tag" "kubernetes_cluster_subnets" {
  for_each = toset(distinct(concat(var.kubernetes_subnet_ids, var.kubernetes_elb_subnet_ids, var.kubernetes_internal_elb_subnet_ids)))

  resource_id = each.value
  key         = "kubernetes.io/cluster/${local.kubernetes_cluster_name}"
  value       = "shared"
}

resource "aws_ec2_tag" "kubernetes_elb_subnets" {
  for_each = toset(var.kubernetes_elb_subnet_ids)

  resource_id = each.value
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

resource "aws_ec2_tag" "kubernetes_internal_elb_subnets" {
  for_each = toset(var.kubernetes_internal_elb_subnet_ids)

  resource_id = each.value
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}
