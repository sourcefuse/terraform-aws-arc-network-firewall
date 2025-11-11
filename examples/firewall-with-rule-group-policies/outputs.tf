output "firewall_arn" {
  description = "ARN of the Network Firewall"
  value       = module.network_firewall.firewall_arn
}

output "firewall_policy_arn" {
  description = "ARN of the firewall policy"
  value       = module.network_firewall.firewall_policy_arn
}

output "firewall_policy_resource_policy_id" {
  description = "ID of the firewall policy resource policy"
  value       = module.network_firewall.firewall_policy_resource_policy_id
}
