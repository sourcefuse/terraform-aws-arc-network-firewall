output "firewall_arn" {
  description = "ARN of the Network Firewall"
  value       = module.network_firewall.firewall_arn
}

output "firewall_policy_arn" {
  description = "ARN of the firewall policy"
  value       = module.network_firewall.firewall_policy_arn
}

output "tls_inspection_configuration_arn" {
  description = "ARN of the TLS inspection configuration"
  value       = module.network_firewall.tls_inspection_configuration_arn
}

output "tls_inspection_configuration_id" {
  description = "ID of the TLS inspection configuration"
  value       = module.network_firewall.tls_inspection_configuration_id
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for TLS inspection encryption"
  value       = aws_kms_key.tls_inspection.arn
}

output "kms_key_alias" {
  description = "Alias of the KMS key"
  value       = aws_kms_alias.tls_inspection.name
}

output "tls_inspection_certificate_authority" {
  description = "Certificate authority information from TLS inspection configuration"
  value       = module.network_firewall.tls_inspection_configuration_certificate_authority
}

output "tls_inspection_certificates" {
  description = "Certificates information from TLS inspection configuration"
  value       = module.network_firewall.tls_inspection_configuration_certificates
}
