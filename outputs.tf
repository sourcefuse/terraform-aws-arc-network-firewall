# Firewall Outputs
output "firewall_id" {
  value       = length(aws_networkfirewall_firewall.this) > 0 ? aws_networkfirewall_firewall.this[0].id : null
  description = "The firewall ID"
}

output "firewall_arn" {
  value       = length(aws_networkfirewall_firewall.this) > 0 ? aws_networkfirewall_firewall.this[0].arn : null
  description = "The firewall ARN"
}

output "firewall_name" {
  value       = length(aws_networkfirewall_firewall.this) > 0 ? aws_networkfirewall_firewall.this[0].name : null
  description = "Firewall name"
}

output "firewall_status" {
  value       = length(aws_networkfirewall_firewall.this) > 0 ? aws_networkfirewall_firewall.this[0].firewall_status : null
  description = "Firewall status"
}

output "firewall_endpoint_ids" {
  description = "Map of endpoint IDs per AZ"
  value = length(aws_networkfirewall_firewall.this) > 0 ? {
    for sync_state in aws_networkfirewall_firewall.this[0].firewall_status[0].sync_states :
    sync_state.availability_zone => sync_state.attachment[0].endpoint_id
  } : {}
}

# Firewall Policy Outputs
output "firewall_policy_id" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall policy"
  value       = var.create_firewall_policy ? aws_networkfirewall_firewall_policy.this[0].id : null
}

output "firewall_policy_arn" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall policy"
  value       = local.firewall_policy_arn
}

output "firewall_policy_name" {
  description = "The name of the firewall policy"
  value       = var.create_firewall_policy ? aws_networkfirewall_firewall_policy.this[0].name : null
}

output "firewall_policy_update_token" {
  description = "A string token used when updating the firewall policy"
  value       = var.create_firewall_policy ? aws_networkfirewall_firewall_policy.this[0].update_token : null
}

# Logging Configuration Outputs
output "logging_configuration_id" {
  description = "The Amazon Resource Name (ARN) of the associated firewall for logging"
  value       = var.enable_logging && length(var.logging_config) > 0 ? aws_networkfirewall_logging_configuration.this[0].id : null
}

# Configuration Outputs
output "vpc_id" {
  description = "The VPC ID where the firewall is deployed"
  # value       = aws_networkfirewall_firewall.this.vpc_id
  value = length(aws_networkfirewall_firewall.this) > 0 ? aws_networkfirewall_firewall.this[0].vpc_id : null
}

output "subnet_ids" {
  description = "List of subnet IDs where firewall endpoints are created"
  value       = var.subnet_ids
}

output "transit_gateway_id" {
  description = "The Transit Gateway ID for transit gateway-attached firewall"
  # value       = aws_networkfirewall_firewall.this.transit_gateway_id
  value = length(aws_networkfirewall_firewall.this) > 0 ? aws_networkfirewall_firewall.this[0].transit_gateway_id : null
}

output "availability_zones" {
  value = length(aws_networkfirewall_firewall.this) > 0 ? [
    for sync_state in aws_networkfirewall_firewall.this[0].firewall_status[0].sync_states :
    sync_state.availability_zone
  ] : []
  description = "Availability zones where firewall endpoints are created"
}

output "tags_all" {
  value       = length(aws_networkfirewall_firewall.this) > 0 ? aws_networkfirewall_firewall.this[0].tags_all : {}
  description = "All tags for the firewall"
}

output "resource_policy_ids" {
  description = "List of resource policy IDs"
  value = concat(
    aws_networkfirewall_resource_policy.firewall_policy[*].id,
  )
}

output "firewall_policy_resource_policy_id" {
  description = "ID of the firewall policy resource policy"
  value       = var.create_firewall_policy && var.create_firewall_policy_resource_policy ? aws_networkfirewall_resource_policy.firewall_policy[0].id : null
}

output "tls_inspection_configuration_arn" {
  description = "ARN of the TLS inspection configuration"
  value       = var.create_tls_inspection_configuration ? aws_networkfirewall_tls_inspection_configuration.this[0].arn : null
}

output "tls_inspection_configuration_id" {
  description = "ID of the TLS inspection configuration"
  value       = var.create_tls_inspection_configuration ? aws_networkfirewall_tls_inspection_configuration.this[0].tls_inspection_configuration_id : null
}

output "tls_inspection_configuration_update_token" {
  description = "Update token of the TLS inspection configuration"
  value       = var.create_tls_inspection_configuration ? aws_networkfirewall_tls_inspection_configuration.this[0].update_token : null
}

output "tls_inspection_configuration_certificate_authority" {
  description = "Certificate authority information"
  value       = var.create_tls_inspection_configuration ? aws_networkfirewall_tls_inspection_configuration.this[0].certificate_authority : null
}

output "tls_inspection_configuration_certificates" {
  description = "Certificates information"
  value       = var.create_tls_inspection_configuration ? aws_networkfirewall_tls_inspection_configuration.this[0].certificates : null
}

# Rule Group Configuration Outputs
output "id" {
  value       = length(aws_networkfirewall_rule_group.this) > 0 ? aws_networkfirewall_rule_group.this[0].id : null
  description = "ID of the rule group"
}

output "arn" {
  value       = length(aws_networkfirewall_rule_group.this) > 0 ? aws_networkfirewall_rule_group.this[0].arn : null
  description = "ARN of the rule group"
}

output "update_token" {
  value       = length(aws_networkfirewall_rule_group.this) > 0 ? aws_networkfirewall_rule_group.this[0].update_token : null
  description = "Update token of the rule group"
}
