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

  # Validate configuration
  validate_firewall_type = local.is_vpc_attached || local.is_tgw_attached ? true : tobool("Either VPC or Transit Gateway configuration must be provided")
  validate_policy_arn = (
    # If firewall is not being created, skip validation
    var.create_firewall == false
    ||
    # If creating firewall, either policy must be created or provided
    var.create_firewall_policy == true
    || var.firewall_policy_arn != null
  ) ? true : false

}
