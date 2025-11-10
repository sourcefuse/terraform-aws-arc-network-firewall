region            = "us-east-1"
firewall_name     = "demo-advanced-firewall"
delete_protection = false

tags = {
  Environment = "demo"
  Project     = "network-firewall-advanced"
  Owner       = "terraform"
  RuleGroups  = "enabled"
}
