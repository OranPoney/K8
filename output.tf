

output "kubernetes_ca_cert" {
  value = base64decode(module.eks.cluster_certificate_authority_data)
}

output "kubernetes_endpoint" {
  value = module.eks.cluster_endpoint
}
  
output "cluster_id" {
  description = "The ID of the EKS cluster. Note: currently a value is returned only for local EKS clusters created on Outposts"
  value       = module.eks.cluster_id
}
