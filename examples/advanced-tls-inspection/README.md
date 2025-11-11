# Advanced TLS Inspection Configuration Example

This example demonstrates a production-ready AWS Network Firewall deployment with advanced TLS inspection capabilities,customer-managed KMS encryption, and sophisticated traffic scoping.

## Features

- **Customer-Managed KMS**: Enhanced security with customer-controlled encryption keys
- **Granular Traffic Scoping**: Different inspection rules for different traffic types
- **Certificate Revocation Checking**: Configurable policies for certificate validation
- **Subject Alternative Names**: Support for multi-domain certificates
- **Production Protection**: All firewall protection settings enabled
- **Advanced Engine Options**: Strict order rule processing

## Best Practices

### Certificate Management
1. **Separate Certificates**: Use different certificates for different services
2. **Regular Rotation**: Implement certificate renewal processes
3. **Validation Monitoring**: Monitor certificate validation status

### Traffic Scoping
1. **Principle of Least Privilege**: Inspect only necessary traffic
2. **Performance Consideration**: Limit scope to reduce processing overhead
3. **Compliance Requirements**: Ensure inspection meets regulatory needs


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
| [aws_kms_alias.tls_inspection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.tls_inspection](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_ssm_parameter.inbound_cert](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.outbound_ca](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_allowed_sources"></a> [api\_allowed\_sources](#input\_api\_allowed\_sources) | Allowed source IP ranges for API access | <pre>list(object({<br/>    address_definition = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "address_definition": "203.0.113.0/24"<br/>  },<br/>  {<br/>    "address_definition": "198.51.100.0/24"<br/>  }<br/>]</pre> | no |
| <a name="input_api_server_destinations"></a> [api\_server\_destinations](#input\_api\_server\_destinations) | Destination IP ranges for API server traffic | <pre>list(object({<br/>    address_definition = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "address_definition": "10.0.10.0/24"<br/>  }<br/>]</pre> | no |
| <a name="input_enable_protection"></a> [enable\_protection](#input\_enable\_protection) | Enable all protection settings | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | `"poc"` | no |
| <a name="input_external_sources"></a> [external\_sources](#input\_external\_sources) | External source IP ranges | <pre>list(object({<br/>    address_definition = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "address_definition": "0.0.0.0/0"<br/>  }<br/>]</pre> | no |
| <a name="input_internal_sources"></a> [internal\_sources](#input\_internal\_sources) | Internal source IP ranges for outbound traffic | <pre>list(object({<br/>    address_definition = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "address_definition": "10.0.0.0/8"<br/>  },<br/>  {<br/>    "address_definition": "172.16.0.0/12"<br/>  },<br/>  {<br/>    "address_definition": "192.168.0.0/16"<br/>  }<br/>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Network Firewall | `string` | `"advanced-tls-firewall"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for resources | `string` | `"arc"` | no |
| <a name="input_outbound_destinations"></a> [outbound\_destinations](#input\_outbound\_destinations) | Destination IP ranges for outbound inspection | <pre>list(object({<br/>    address_definition = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "address_definition": "0.0.0.0/0"<br/>  }<br/>]</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_revocation_policy"></a> [revocation\_policy](#input\_revocation\_policy) | Certificate revocation checking policy | <pre>object({<br/>    revoked_action = string<br/>    unknown_action = string<br/>  })</pre> | <pre>{<br/>  "revoked_action": "REJECT",<br/>  "unknown_action": "PASS"<br/>}</pre> | no |
| <a name="input_web_server_destinations"></a> [web\_server\_destinations](#input\_web\_server\_destinations) | Destination IP ranges for web server traffic | <pre>list(object({<br/>    address_definition = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "address_definition": "10.0.1.0/24"<br/>  },<br/>  {<br/>    "address_definition": "10.0.2.0/24"<br/>  }<br/>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_arn"></a> [firewall\_arn](#output\_firewall\_arn) | ARN of the Network Firewall |
| <a name="output_firewall_policy_arn"></a> [firewall\_policy\_arn](#output\_firewall\_policy\_arn) | ARN of the firewall policy |
| <a name="output_kms_key_alias"></a> [kms\_key\_alias](#output\_kms\_key\_alias) | Alias of the KMS key |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | ARN of the KMS key used for TLS inspection encryption |
| <a name="output_tls_inspection_certificate_authority"></a> [tls\_inspection\_certificate\_authority](#output\_tls\_inspection\_certificate\_authority) | Certificate authority information from TLS inspection configuration |
| <a name="output_tls_inspection_certificates"></a> [tls\_inspection\_certificates](#output\_tls\_inspection\_certificates) | Certificates information from TLS inspection configuration |
| <a name="output_tls_inspection_configuration_arn"></a> [tls\_inspection\_configuration\_arn](#output\_tls\_inspection\_configuration\_arn) | ARN of the TLS inspection configuration |
| <a name="output_tls_inspection_configuration_id"></a> [tls\_inspection\_configuration\_id](#output\_tls\_inspection\_configuration\_id) | ID of the TLS inspection configuration |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
