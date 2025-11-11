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

# output "inbound_certificate_arn" {
#   description = "ARN of the inbound certificate"
#   value       = aws_acm_certificate.inbound.arn
# }

# output "outbound_ca_certificate_arn" {
#   description = "ARN of the outbound CA certificate"
#   value       = aws_acm_certificate.outbound_ca.arn
# }
