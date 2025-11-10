# Network Firewall with Rule Group Resource Policies Example

This example demonstrates how to deploy an AWS Network Firewall with resource policies for both the firewall policy and custom rule groups, enabling cross-account access control.

## Features

- Custom stateful rule group creation
- Network Firewall deployment with custom rule groups
- Resource policies for both firewall policy and rule groups
- Cross-account access control for rule group management

## Architecture

```
Custom Rule Group (with resource policy)
         ↓
Network Firewall Policy (with resource policy)
         ↓
Network Firewall
```

## Usage

1. Update the `trusted_account_arn` in `example.auto.tfvars` with your trusted AWS account ARN
2. Run Terraform commands:

```bash
terraform init
terraform plan
terraform apply
```

## Resource Policies

### Firewall Policy Resource Policy
Allows the trusted account to:
- List firewall policies
- Create firewalls
- Update firewalls
- Associate firewall policies

### Rule Group Resource Policy
Allows the trusted account to:
- List rule groups
- Create firewall policies
- Update firewall policies

## Variables

- `trusted_account_arn`: ARN of the AWS account that should have access to the firewall policy and rule groups
- `region`: AWS region for deployment
- `environment`: Environment name for resource tagging
- `namespace`: Namespace for resource naming

## Outputs

- `firewall_arn`: ARN of the created Network Firewall
- `firewall_policy_arn`: ARN of the firewall policy
- `rule_group_arn`: ARN of the custom rule group
- `resource_policy_ids`: IDs of all created resource policies
- `firewall_policy_resource_policy_id`: ID of the firewall policy resource policy
