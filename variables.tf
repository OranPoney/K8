variable "name" {
  description = "Name to be used on all the resources as identifier"
  default     = "kubernetes"
}

variable "aws_allowed_account_ids" {
  description = "AWS account number(s) used to build resources in"
  default = ["083928272245"]
}

variable "aws_region" {
  description = "AWS region to build resources in"
  default = "us-east-1"
}

variable "cluster_autoscaler_enabled" {
  description = "Creates IAM resources and install cluster-autoscaler"
  default     = true
}

variable "cluster_autoscaler_values" {
  description = "Values for cluster-autoscaler chart"
  default     = ""
}

variable "ingress_nginx_enabled" {
  description = "Install ingress-nginx to cluster"
  default     = true
}

variable "ingress_nginx_namespace" {
  description = "Namespace for ingress-nginx"
  default     = "ingress-system"
}

variable "ingress_nginx_values" {
  description = "Values for ingress-nginx chart"
  default     = ""
}

variable "kube_state_metrics_values" {
  description = "Values for kube-state-metrics chart"
  default     = ""
}

variable "kubernetes_backup_bucket_create" {
  description = "Create S3 bucket used for cluster backups"
  default     = true
}

variable "kubernetes_backup_bucket_name" {
  description = "Name for S3 bucket used for cluster backups"
  default     = ""
}

variable "kubernetes_cluster_name" {
  description = "Kubernetes cluster name"
  default     = ""
}

variable "kubernetes_cluster_version" {
  description = "Version of Kubernetes"
  default     = "1.19"
}

variable "kubernetes_enable_irsa" {
  description = "Enable AWS OIDC auth for ServiceAccounts"
  default     = true
}

variable "kubernetes_cluster_endpoint_private_access" {
  description = "Allows access to Kubernetes control plane on private addresses"
  default     = true
}

variable "kubernetes_cluster_endpoint_private_access_cidrs" {
  description = "CIDRs allowed to access the Kubernetes control plane on a private address"
  default     = [""]
}

variable "kubernetes_cluster_endpoint_public_access" {
  description = "Allows access to Kubernetes control plane on public addresses"
  default     = true
}

variable "kubernetes_cluster_endpoint_public_access_cidrs" {
  description = "CIDRs allowed to access the Kubernetes control plane on a public address"
  default     = []
}

variable "kubernetes_manage_aws_auth" {
  description = "Allow Terraform to manage aws-auth configmap"
  default     = true
}
variable "kubernetes_subnet_ids" {
  description = "Subnets from existing VPC for Kubernetes cluster"
  default     = []
}

variable "kubernetes_application_nodes_instance_type" {
  description = "Kubernetes application node type"
  default     = "m5a.large"
}

variable "kubernetes_application_nodes_instance_desired_capacity" {
  description = "Desired worker capacity in the autoscaling group"
  default     = 1
}

variable "kubernetes_application_nodes_instance_min_capacity" {
  description = "Minimum worker capacity in the autoscaling group"
  default     = 1
}

variable "kubernetes_application_nodes_instance_max_capacity" {
  description = "Desired worker capacity in the autoscaling group"
  default     = 6
}

variable "kubernetes_elb_subnet_ids" {
  description = "Existing VPC public subnets for public service ELBs"
  default     = []
  type        = list(string)
}

variable "kubernetes_internal_elb_subnet_ids" {
  description = "Existing VPC private subnets for internal service ELBs"
  default     = []
  type        = list(string)
}

variable "kubernetes_system_nodes_instance_type" {
  description = "Kubernetes system node type"
  default     = "m5a.large"
}

variable "kubernetes_system_nodes_instance_desired_capacity" {
  description = "Desired worker capacity in the autoscaling group"
  default     = 1
}

variable "kubernetes_system_nodes_instance_min_capacity" {
  description = "Minimum worker capacity in the autoscaling group"
  default     = 1
}

variable "kubernetes_system_nodes_instance_max_capacity" {
  description = "Desired worker capacity in the autoscaling group"
  default     = 6
}

variable "kubernetes_enable_monitoring" {
  description = "Enables detailed metrics on nodes"
  default     = false
}

variable "kubernetes_root_encrypted" {
  description = "Encrypt root volume on nodes"
  default     = true
}

variable "kubernetes_root_volume_size" {
  description = "Size of root volume"
  default     = 100
}

variable "sock_shop_enabled" {
  description = "Install sock-shop"
  default     = true
}

variable "sock_shop_values" {
  description = "Values for sock-shop chart"
  default     = ""
}

variable "tags" {
  description = "Tags applied to all resources"
  default = {}
}

variable "velero_enabled" {
  description = "Creates IAM resources for Velero"
  default     = true
}

variable "vpc_create" {
  description = "Enables creation of vpc"
  default     = true
}

variable "vpc_name" {
  description = "Name to be used on VPC resources as identifier"
  default     = ""
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.128.0.0/16"
}

variable "vpc_azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "vpc_create_igw" {
  description = "Controls if an Internet Gateway is created for public subnets and the related routes that connect them."
  default     = true
}

variable "vpc_enable_dns_hostnames" {
  description = "Should be true to enable DNS hostnames in the VPC"
  default     = true
}

variable "vpc_enable_dns_support" {
  description = "Should be true to enable DNS support in the VPC"
  default     = true
}

variable "vpc_enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  default     = true
}

variable "vpc_database_subnets" {
  description = "A list of cidr blocks for the database subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "vpc_public_subnets" {
  description = "A list of cidr blocks for the public subnets inside the VPC"
  type        = list(string)
  default     = ["10.128.0.0/24","10.128.1.0/24","10.128.2.0/24"]
}

variable "vpc_private_subnets" {
  description = "A list of cidr blocks for the private subnets inside the VPC"
  type        = list(string)
  default     = ["10.128.4.0/22","10.128.8.0/22","10.128.12.0/22"]
}

variable "vpc_single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  default     = true
}

variable "vpc_one_nat_gateway_per_az" {
  description = "Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`."
  default     = false
}

variable "vpc_enable_s3_endpoint" {
  description = "Should be true if you want to provision an S3 endpoint to the VPC"
  default     = false
}

variable "vpc_enable_ec2_endpoint" {
  description = "Should be true if you want to provision an EC2 endpoint to the VPC"
  default     = false
}

variable "vpc_ec2_endpoint_security_group_ids" {
  description = "The ID of one or more security groups to associate with the network interface for EC2 endpoint"
  type        = list(string)
  default     = []
}

variable "vpc_ec2_endpoint_private_dns_enabled" {
  description = "Whether or not to associate a private hosted zone with the specified VPC for EC2 endpoint"
  type        = bool
  default     = false
}

variable "vpc_ec2_endpoint_subnet_ids" {
  description = "The ID of one or more subnets in which to create a network interface for EC2 endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "vpc_enable_ec2_autoscaling_endpoint" {
  description = "Should be true if you want to provision an EC2 Autoscaling endpoint to the VPC"
  type        = bool
  default     = false
}

variable "vpc_ec2_autoscaling_endpoint_security_group_ids" {
  description = "The ID of one or more security groups to associate with the network interface for EC2 Autoscaling endpoint"
  type        = list(string)
  default     = []
}

variable "vpc_ec2_autoscaling_endpoint_private_dns_enabled" {
  description = "Whether or not to associate a private hosted zone with the specified VPC for EC2 Autoscaling endpoint"
  type        = bool
  default     = false
}

variable "vpc_ec2_autoscaling_endpoint_subnet_ids" {
  description = "The ID of one or more subnets in which to create a network interface for EC2 Autoscaling endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "vpc_enable_ecr_api_endpoint" {
  description = "Should be true if you want to provision an ecr api endpoint to the VPC"
  type        = bool
  default     = false
}

variable "vpc_ecr_api_endpoint_subnet_ids" {
  description = "The ID of one or more subnets in which to create a network interface for ECR api endpoint. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "vpc_ecr_api_endpoint_private_dns_enabled" {
  description = "Whether or not to associate a private hosted zone with the specified VPC for ECR API endpoint"
  type        = bool
  default     = false
}

variable "vpc_ecr_api_endpoint_security_group_ids" {
  description = "The ID of one or more security groups to associate with the network interface for ECR API endpoint"
  type        = list(string)
  default     = []
}

variable "vpc_enable_ecr_dkr_endpoint" {
  description = "Should be true if you want to provision an ecr dkr endpoint to the VPC"
  type        = bool
  default     = false
}

variable "vpc_ecr_dkr_endpoint_subnet_ids" {
  description = "The ID of one or more subnets in which to create a network interface for ECR dkr endpoint. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "vpc_ecr_dkr_endpoint_private_dns_enabled" {
  description = "Whether or not to associate a private hosted zone with the specified VPC for ECR DKR endpoint"
  type        = bool
  default     = false
}

variable "vpc_ecr_dkr_endpoint_security_group_ids" {
  description = "The ID of one or more security groups to associate with the network interface for ECR DKR endpoint"
  type        = list(string)
  default     = []
}

variable "vpc_enable_ebs_endpoint" {
  description = "Should be true if you want to provision an EBS endpoint to the VPC"
  type        = bool
  default     = false
}

variable "vpc_ebs_endpoint_security_group_ids" {
  description = "The ID of one or more security groups to associate with the network interface for EBS endpoint"
  type        = list(string)
  default     = []
}

variable "vpc_ebs_endpoint_subnet_ids" {
  description = "The ID of one or more subnets in which to create a network interface for EBS endpoint. Only a single subnet within an AZ is supported. Ifomitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "vpc_ebs_endpoint_private_dns_enabled" {
  description = "Whether or not to associate a private hosted zone with the specified VPC for EBS endpoint"
  type        = bool
  default     = false
}

variable "vpc_enable_kms_endpoint" {
  description = "Should be true if you want to provision a KMS endpoint to the VPC"
  type        = bool
  default     = false
}

variable "vpc_kms_endpoint_security_group_ids" {
  description = "The ID of one or more security groups to associate with the network interface for KMS endpoint"
  type        = list(string)
  default     = []
}

variable "vpc_kms_endpoint_subnet_ids" {
  description = "The ID of one or more subnets in which to create a network interface for KMS endpoint. Only a single subnet within an AZ is supported. If omitted, private subnets will be used."
  type        = list(string)
  default     = []
}

variable "vpc_kms_endpoint_private_dns_enabled" {
  description = "Whether or not to associate a private hosted zone with the specified VPC for KMS endpoint"
  type        = bool
  default     = false
}
