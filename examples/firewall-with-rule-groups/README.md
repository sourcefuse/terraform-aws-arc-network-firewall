# Advanced Network Firewall with Rule Groups

This example demonstrates how to create an AWS Network Firewall with custom stateful and stateless rule groups, including Suricata-compatible rules and AWS managed rule groups.

## What This Example Creates

- A Network Firewall with advanced configuration
- Custom stateless rule group (ICMP allow)
- Custom stateful rule group with Suricata rules
- AWS managed rule group integration
- Advanced firewall policy with strict ordering
- Custom metric actions

## Features Demonstrated

- **Stateless Rule Groups**: Custom rules for protocol-based filtering
- **Stateful Rule Groups**: Suricata-compatible rules for deep packet inspection
- **AWS Managed Rules**: Integration with AWS threat intelligence
- **Strict Rule Ordering**: Deterministic rule evaluation
- **Policy Variables**: Centralized network definitions
- **Custom Actions**: CloudWatch metrics integration
- **Protection Settings**: All protection mechanisms enabled

## Rule Groups Included

### Stateless Rules
- Allow ICMP traffic from any source to any destination

### Stateful Rules (Suricata Format)
- Allow HTTP traffic to example.com
- Allow TLS traffic to example.com
- Block SSH traffic (port 22)

## Configuration Details

### Engine Options
- **Rule Order**: STRICT_ORDER for deterministic evaluation
- **Stream Exception Policy**: DROP for broken connections
- **TCP Idle Timeout**: 300 seconds

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.11.0 |

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
| <a name="input_delete_protection"></a> [delete\_protection](#input\_delete\_protection) | Enable deletion protection for the firewall | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment, i.e. dev, stage, prod | `string` | `"poc"` | no |
| <a name="input_firewall_name"></a> [firewall\_name](#input\_firewall\_name) | Name of the Network Firewall | `string` | `"advanced-network-firewall"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace of the project, i.e. arc | `string` | `"arc"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_arn"></a> [firewall\_arn](#output\_firewall\_arn) | ARN of the Network Firewall |
| <a name="output_firewall_endpoint_ids"></a> [firewall\_endpoint\_ids](#output\_firewall\_endpoint\_ids) | Map of firewall endpoint IDs by availability zone |
| <a name="output_firewall_name"></a> [firewall\_name](#output\_firewall\_name) | Name of the Network Firewall |
| <a name="output_firewall_policy_arn"></a> [firewall\_policy\_arn](#output\_firewall\_policy\_arn) | ARN of the Firewall Policy |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID where the firewall is deployed |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
