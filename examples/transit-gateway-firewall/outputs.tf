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

output "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  value       = aws_ec2_transit_gateway.main.id
}

output "transit_gateway_arn" {
  description = "ARN of the Transit Gateway"
  value       = aws_ec2_transit_gateway.main.arn
}

# output "vpc_id" {
#   description = "ID of the VPC"
#   value       = aws_vpc.test.id
# }

# output "vpc_cidr_block" {
#   description = "CIDR block of the VPC"
#   value       = aws_vpc.test.cidr_block
# }

# output "private_subnet_ids" {
#   description = "IDs of the private subnets"
#   value       = aws_subnet.private[*].id
# }

output "tgw_vpc_attachment_id" {
  description = "ID of the Transit Gateway VPC attachment"
  value       = aws_ec2_transit_gateway_vpc_attachment.main.id
}

output "availability_zones" {
  description = "Availability zones where firewall endpoints are deployed"
  value       = module.network_firewall.availability_zones
}
