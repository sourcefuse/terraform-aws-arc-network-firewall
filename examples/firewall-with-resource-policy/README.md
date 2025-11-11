# Network Firewall with Resource Policy Example

This example demonstrates how to deploy an AWS Network Firewall with resource policies that control cross-account access to the firewall policy.

## Features

- Basic Network Firewall deployment in default VPC
- Resource policy for firewall policy allowing cross-account access
- Configurable trusted account ARN

## Resource Policy

The example creates a resource policy that allows the specified trusted account to:
- List firewall policies
- Create firewalls
- Update firewalls  
- Associate firewall policies


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
| <a name="input_name"></a> [name](#input\_name) | Name of the Network Firewall | `string` | `"example-firewall-with-resource-policy"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for resources | `string` | `"arc"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_arn"></a> [firewall\_arn](#output\_firewall\_arn) | ARN of the Network Firewall |
| <a name="output_firewall_policy_arn"></a> [firewall\_policy\_arn](#output\_firewall\_policy\_arn) | ARN of the firewall policy |
| <a name="output_firewall_policy_resource_policy_id"></a> [firewall\_policy\_resource\_policy\_id](#output\_firewall\_policy\_resource\_policy\_id) | ID of the firewall policy resource policy |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
