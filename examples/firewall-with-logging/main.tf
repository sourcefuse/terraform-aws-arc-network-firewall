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



# Network Firewall with Comprehensive Logging
module "network_firewall" {
  source = "../../"

  name            = var.firewall_name
  description     = "Network Firewall with comprehensive logging configuration"
  create_firewall = true
  firewall_config = {
    delete_protection      = var.delete_protection
    enabled_analysis_types = ["HTTP_HOST"]
  }

  # VPC Configuration
  vpc_id     = data.aws_vpc.default.id
  subnet_ids = slice(data.aws_subnets.public.ids, 0, min(2, length(data.aws_subnets.public.ids)))

  # Firewall Policy Configuration
  firewall_policy_config = {
    create                             = true
    name                               = "${var.firewall_name}-policy"
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
  }

  # Enable Logging
  logging_config = {
    enable = true
    destinations = [
      {
        log_type             = "FLOW"
        log_destination_type = "S3"
        log_destination_name = "my-firewall-flow-logs"
      },
      {
        log_type             = "ALERT"
        log_destination_type = "CloudWatchLogs"
        log_destination_name = "my-firewall-alert-logs"
      }
    ]
  }

  vpc_endpoint_association = {
    create      = true
    description = "Network Firewall endpoint for public subnets"
    subnet_mappings = [
      {
        subnet_id       = element(data.aws_subnets.public.ids, 0)
        ip_address_type = "IPV4"
      }
    ]
  }
  tags = module.tags.tags

}
