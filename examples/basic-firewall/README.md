# Basic Network Firewall Example

This example demonstrates how to create a basic AWS Network Firewall with minimal configuration.

## What This Example Creates

- A Network Firewall in the default VPC
- A basic firewall policy with default actions
- Firewall endpoints in available subnets

## Features Demonstrated

- Basic VPC-attached firewall deployment
- Default firewall policy creation
- Minimal required configuration
- Standard tagging practices

## Configuration

The example uses the following default settings:

- **Default Actions**: Forward to stateful engine (`aws:forward_to_sfe`)
- **Fragment Actions**: Forward to stateful engine (`aws:forward_to_sfe`)
- **VPC**: Uses the default VPC in the region
- **Subnets**: Uses up to 2 available subnets from the default VPC
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
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment, i.e. dev, stage, prod | `string` | `"poc"` | no |
| <a name="input_firewall_name"></a> [firewall\_name](#input\_firewall\_name) | Name of the Network Firewall | `string` | `"basic-network-firewall"` | no |
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
