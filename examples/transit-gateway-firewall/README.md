# Transit Gateway-Attached Network Firewall Example

This example demonstrates how to deploy an AWS Network Firewall attached to a Transit Gateway using SourceFuse open-source Terraform modules for infrastructure provisioning.

## Features

- **SourceFuse Modules**: Uses production-ready open-source modules for VPC and Transit Gateway
- **Transit Gateway Integration**: Firewall attached directly to Transit Gateway for centralized inspection
- **Multi-AZ Deployment**: High availability across multiple availability zones
- **Centralized Security**: Single point of control for traffic inspection across multiple VPCs
- **Scalable Architecture**: Easy to add more VPC attachments to the Transit Gateway

## Architecture

```
    VPC (via SourceFuse Module)
           |
    Transit Gateway (via SourceFuse Module)
           |
    Network Firewall
           |
    Internet/Other Networks
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0, < 7.0 |

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
| [aws_ec2_transit_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway) | resource |
| [aws_ec2_transit_gateway_vpc_attachment.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_vpc_attachment) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_delete_protection"></a> [delete\_protection](#input\_delete\_protection) | Enable deletion protection for the firewall | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment, i.e. dev, stage, prod | `string` | `"poc"` | no |
| <a name="input_firewall_name"></a> [firewall\_name](#input\_firewall\_name) | Name of the Network Firewall | `string` | `"tgw-network-firewall"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace of the project, i.e. arc | `string` | `"arc"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_zones"></a> [availability\_zones](#output\_availability\_zones) | Availability zones where firewall endpoints are deployed |
| <a name="output_firewall_arn"></a> [firewall\_arn](#output\_firewall\_arn) | ARN of the Network Firewall |
| <a name="output_firewall_name"></a> [firewall\_name](#output\_firewall\_name) | Name of the Network Firewall |
| <a name="output_firewall_policy_arn"></a> [firewall\_policy\_arn](#output\_firewall\_policy\_arn) | ARN of the Firewall Policy |
| <a name="output_tgw_vpc_attachment_id"></a> [tgw\_vpc\_attachment\_id](#output\_tgw\_vpc\_attachment\_id) | ID of the Transit Gateway VPC attachment |
| <a name="output_transit_gateway_arn"></a> [transit\_gateway\_arn](#output\_transit\_gateway\_arn) | ARN of the Transit Gateway |
| <a name="output_transit_gateway_id"></a> [transit\_gateway\_id](#output\_transit\_gateway\_id) | ID of the Transit Gateway |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
