output "evolven_collection_token" {
  value = data.kubernetes_secret.evolven_collection.data["token"]
}

output "kubernetes_ca_cert" {
  value = base64decode(module.eks.cluster_certificate_authority_data)
}

output "kubernetes_endpoint" {
  value = module.eks.cluster_endpoint
}
