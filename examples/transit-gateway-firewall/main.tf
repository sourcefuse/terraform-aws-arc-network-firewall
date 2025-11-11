################################################################################
## Tags
################################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.3"

  environment = var.environment
  project     = var.namespace

  extra_tags = {
    RepoName = "terraform-aws-arc-network-firewall"
  }
}


# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

# Transit Gateway
resource "aws_ec2_transit_gateway" "main" {
  description                     = "Transit Gateway for Network Firewall demo"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  tags = merge(module.tags.tags, {
    Name = "${var.firewall_name}-tgw"
  })
}

# Transit Gateway VPC Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "main" {
  subnet_ids         = data.aws_subnets.private.ids
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = data.aws_vpc.default.id

  tags = merge(module.tags.tags, {
    Name = "${var.firewall_name}-tgw-attachment"
  })
}

# Network Firewall attached to Transit Gateway
module "network_firewall" {
  source = "../../"

  name        = var.firewall_name
  description = "Transit Gateway-attached Network Firewall"

  create_firewall = true
  firewall_policy_config = {
    create = true
  }

  # Transit Gateway Setup
  availability_zones = slice(data.aws_availability_zones.available.zone_ids, 0, 2)

  firewall_config = {
    transit_gateway_id = aws_ec2_transit_gateway.main.id

    # Protection flags
    delete_protection                   = var.delete_protection
    availability_zone_change_protection = true
    firewall_policy_change_protection   = true

    # Engine + default actions
    enabled_analysis_types = []
    stateful_engine_options = {
      rule_order              = "STRICT_ORDER"
      stream_exception_policy = "DROP"
    }

    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
    stateful_default_actions           = ["aws:drop_strict"]
  }

  tags = module.tags.tags

  depends_on = [
    aws_ec2_transit_gateway.main
  ]
}
