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

# output "kinesis_firehose_stream" {
#   description = "Kinesis Data Firehose delivery stream (if enabled)"
#   value       = var.enable_kinesis_firehose ? aws_kinesis_firehose_delivery_stream.firewall_logs[0].name : null
# }

output "logging_configuration_id" {
  description = "Logging configuration ID"
  value       = module.network_firewall.logging_configuration_id
}
