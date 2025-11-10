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


module "network_firewall" {
  source = "../../"

  name       = var.name
  vpc_id     = data.aws_vpc.default.id
  subnet_ids = slice(data.aws_subnets.public.ids, 0, min(2, length(data.aws_subnets.public.ids)))

  create_firewall        = true
  create_firewall_policy = true

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
