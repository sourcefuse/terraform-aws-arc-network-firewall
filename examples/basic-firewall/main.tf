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


# Basic Network Firewall
module "network_firewall" {
  source = "../../"

  name        = var.firewall_name
  description = "Basic Network Firewall for demonstration"

  create_firewall = true
  # VPC Configuration
  vpc_id     = data.aws_vpc.default.id
  subnet_ids = slice(data.aws_subnets.public.ids, 0, min(2, length(data.aws_subnets.public.ids)))

  # Basic firewall policy using new single-config object
  firewall_policy_config = {
    create      = true
    name        = "${var.firewall_name}-policy"
    description = "Basic firewall policy"

    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
  }

  tags = module.tags.tags
}
