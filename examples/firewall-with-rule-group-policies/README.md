# Network Firewall with Rule Group Resource Policies Example

This example demonstrates how to deploy an AWS Network Firewall with resource policies for both the firewall policy and custom rule groups, enabling cross-account access control.

## Features

- Custom stateful rule group creation
- Network Firewall deployment with custom rule groups
- Resource policies for both firewall policy and rule groups
- Cross-account access control for rule group management

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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.16.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_network_firewall"></a> [network\_firewall](#module\_network\_firewall) | ../../ | n/a |
| <a name="module_tags"></a> [tags](#module\_tags) | sourcefuse/arc-tags/aws | 1.2.3 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | `"poc"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Network Firewall | `string` | `"firewall-with-rule-group-policies"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for resources | `string` | `"arc"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_arn"></a> [firewall\_arn](#output\_firewall\_arn) | ARN of the Network Firewall |
| <a name="output_firewall_policy_arn"></a> [firewall\_policy\_arn](#output\_firewall\_policy\_arn) | ARN of the firewall policy |
| <a name="output_firewall_policy_resource_policy_id"></a> [firewall\_policy\_resource\_policy\_id](#output\_firewall\_policy\_resource\_policy\_id) | ID of the firewall policy resource policy |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
