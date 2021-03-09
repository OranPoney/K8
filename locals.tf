locals {
  availability_zones = coalescelist(var.vpc_azs, tolist(data.aws_availability_zones.available.names))
  kubernetes_cluster_name                          = coalesce(var.kubernetes_cluster_name, var.name)
  kubernetes_subnet_ids                            = length(var.kubernetes_subnet_ids) > 0 ? var.kubernetes_subnet_ids : module.vpc.0.private_subnets
  kubernetes_cluster_endpoint_private_access_cidrs = coalescelist(var.kubernetes_cluster_endpoint_private_access_cidrs, [data.aws_vpc.kubernetes.cidr_block])
  kubernetes_cluster_endpoint_public_access_cidrs  = coalescelist(var.kubernetes_cluster_endpoint_public_access_cidrs, ["0.0.0.0/0"])
  kubernetes_vpc_id                                = data.aws_subnet.kubernetes.0.vpc_id
  kubernetes_backup_bucket_name = lower(
    coalesce(var.kubernetes_backup_bucket_name,
      format("%s-backup-%s-%s",
        local.kubernetes_cluster_name,
        data.aws_region.current.name,
        data.aws_caller_identity.current.account_id
      )
    )
  )
  vpc_name                            = coalesce(var.vpc_name, var.name)
}
