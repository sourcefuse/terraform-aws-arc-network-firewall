output "firewall_arn" {
  description = "ARN of the Network Firewall"
  value       = module.network_firewall.firewall_arn
}

output "firewall_name" {
  description = "Name of the Network Firewall"
  value       = module.network_firewall.firewall_name
}

output "firewall_policy_arn" {
  description = "ARN of the Firewall Policy"
  value       = module.network_firewall.firewall_policy_arn
}

output "firewall_endpoint_ids" {
  description = "Map of firewall endpoint IDs by availability zone"
  value       = module.network_firewall.firewall_endpoint_ids
}

output "vpc_id" {
  description = "VPC ID where the firewall is deployed"
  value       = module.network_firewall.vpc_id
}
