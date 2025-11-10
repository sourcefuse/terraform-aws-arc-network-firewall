locals {
  # Determine firewall type
  is_vpc_attached = var.vpc_id != null && length(var.subnet_ids) > 0
  is_tgw_attached = try(var.firewall_config.transit_gateway_id, null) != null && length(var.availability_zones) > 0

  # Firewall policy ARN to use
  firewall_policy_arn = var.create_firewall_policy ? aws_networkfirewall_firewall_policy.this[0].arn : var.firewall_policy_arn

  # Subnet mappings for VPC-attached firewall
  subnet_mappings = local.is_vpc_attached ? [
    for subnet_id in var.subnet_ids : {
      subnet_id = subnet_id
    }
  ] : []

  # Availability zone mappings for TGW-attached firewall
  az_mappings = local.is_tgw_attached ? [
    for az_id in var.availability_zones : {
      availability_zone_id = az_id
    }
  ] : []
}
