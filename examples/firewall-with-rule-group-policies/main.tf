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


# Network Firewall with rule group resource policies
module "network_firewall" {
  source = "../../"

  name       = var.name
  vpc_id     = data.aws_vpc.default.id
  subnet_ids = slice(data.aws_subnets.public.ids, 0, min(2, length(data.aws_subnets.public.ids)))

  rule_group_config = {
    create   = true
    type     = "STATEFUL"
    capacity = 100

    rules_source = {
      rules_source_list = [
        {
          generated_rules_type = "ALLOWLIST"
          target_types         = ["TLS_SNI", "HTTP_HOST"]
          targets              = ["example.com", "test.com"]
        }
      ]
    }
  }


  firewall_policy_config = {
    create = true
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
  # Resource policies for external rule groups
  create_rule_group_resource_policy = true
  rule_group_resource_policy = {
    statements = [
      {
        actions = [
          "network-firewall:ListRuleGroups",
          "network-firewall:CreateFirewallPolicy",
          "network-firewall:UpdateFirewallPolicy"
        ]
        effect = "Allow"

        principals = {
          aws = [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
          ]
        }
      }
    ]
  }
  tags = module.tags.tags
}
