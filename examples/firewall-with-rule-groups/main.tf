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


# Network Firewall with Rule Groups
module "network_firewall" {
  source = "../../"

  name            = var.firewall_name
  description     = "Advanced Network Firewall with custom and managed rule groups"
  create_firewall = true
  # VPC Configuration
  vpc_id     = data.aws_vpc.default.id
  subnet_ids = slice(data.aws_subnets.public.ids, 0, min(2, length(data.aws_subnets.public.ids)))
  firewall_config = {
    delete_protection                   = var.delete_protection
    subnet_change_protection            = true
    firewall_policy_change_protection   = true
    availability_zone_change_protection = false
  }

  firewall_policy_config = {
    create      = true
    name        = "${var.firewall_name}-policy"
    description = "Advanced policy with stateful and stateless rules"

    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
    stateful_default_actions           = ["aws:drop_strict"]

    stateful_engine_options = {
      rule_order              = "STRICT_ORDER"
      stream_exception_policy = "DROP"
      flow_timeouts = {
        tcp_idle_timeout_seconds = 300
      }
    }

    policy_variables = {
      rule_variables = {
        HOME_NET = {
          definition = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
        }
      }
    }

  }

  # # Rule Groups
  rule_group_config = {
    create   = true
    type     = "STATEFUL"
    capacity = 100

    rules_source = {
      stateful_rules = [
        {
          action = "DROP"
          header = {
            destination      = "124.1.1.24/32"
            destination_port = "53"
            direction        = "ANY"
            protocol         = "TCP"
            source           = "1.2.3.4/32"
            source_port      = "53"
          }
          rule_options = [
            { keyword = "sid", settings = ["1"] }
          ]
        }
      ]
    }
  }

  # Resource policy for firewall policy
  create_firewall_policy_resource_policy = true
  firewall_policy_resource_policy = {
    statements = [
      {
        actions = [
          "network-firewall:AssociateFirewallPolicy",
          "network-firewall:ListFirewallPolicies"
        ]
        effect = "Allow"
        principals = {
          aws = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
        }
      }
    ]
  }
  tags = module.tags.tags
}
