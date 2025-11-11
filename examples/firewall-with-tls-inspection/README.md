# Network Firewall with TLS Inspection Example

This example demonstrates how to deploy an AWS Network Firewall with TLS inspection capabilities for both inbound and outbound traffic inspection.

## Features

- **Inbound TLS Inspection**: Inspect incoming SSL/TLS traffic using server certificates
- **Outbound TLS Inspection**: Inspect outgoing SSL/TLS traffic using certificate authority
- **Certificate Revocation Checking**: Validate certificate status using OCSP/CRL
- **Flexible Scoping**: Configure inspection for specific protocols, ports, and IP ranges
- **AWS-Owned KMS Encryption**: Secure configuration with AWS-managed encryption

## Architecture

```
Internet ←→ Network Firewall (TLS Inspection) ←→ VPC Resources
              ↓
        TLS Inspection Configuration
              ↓
    [Inbound Cert] + [Outbound CA Cert]
```

## TLS Inspection Configuration

### Inbound Inspection
- **Purpose**: Inspect traffic coming into your network
- **Certificate**: Server certificate for decryption
- **Scope**: All traffic on port 443 from any source

### Outbound Inspection  
- **Purpose**: Inspect traffic going out of your network
- **Certificate**: Certificate Authority for validation
- **Revocation Check**: REJECT revoked certificates, PASS unknown status
- **Scope**: Traffic from internal networks (10.0.0.0/8) to any destination

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
| [aws_ssm_parameter.inbound_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.outbound_ca](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | `"poc"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Network Firewall | `string` | `"firewall-with-tls-inspection"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for resources | `string` | `"arc"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_arn"></a> [firewall\_arn](#output\_firewall\_arn) | ARN of the Network Firewall |
| <a name="output_firewall_policy_arn"></a> [firewall\_policy\_arn](#output\_firewall\_policy\_arn) | ARN of the firewall policy |
| <a name="output_tls_inspection_configuration_arn"></a> [tls\_inspection\_configuration\_arn](#output\_tls\_inspection\_configuration\_arn) | ARN of the TLS inspection configuration |
| <a name="output_tls_inspection_configuration_id"></a> [tls\_inspection\_configuration\_id](#output\_tls\_inspection\_configuration\_id) | ID of the TLS inspection configuration |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
