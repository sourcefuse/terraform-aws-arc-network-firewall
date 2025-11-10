# Network Firewall with Resource Policy Example

This example demonstrates how to deploy an AWS Network Firewall with resource policies that control cross-account access to the firewall policy.

## Features

- Basic Network Firewall deployment in default VPC
- Resource policy for firewall policy allowing cross-account access
- Configurable trusted account ARN

## Usage

1. Update the `trusted_account_arn` in `example.auto.tfvars` with your trusted AWS account ARN
2. Run Terraform commands:

```bash
terraform init
terraform plan
terraform apply
```

## Resource Policy

The example creates a resource policy that allows the specified trusted account to:
- List firewall policies
- Create firewalls
- Update firewalls  
- Associate firewall policies

## Variables

- `trusted_account_arn`: ARN of the AWS account that should have access to the firewall policy

## Outputs

- `firewall_arn`: ARN of the created Network Firewall
- `firewall_policy_arn`: ARN of the firewall policy
- `resource_policy_ids`: IDs of the created resource policies
