# Advanced TLS Inspection Configuration Example

This example demonstrates a production-ready AWS Network Firewall deployment with advanced TLS inspection capabilities,customer-managed KMS encryption, and sophisticated traffic scoping.

## Features

- **Customer-Managed KMS**: Enhanced security with customer-controlled encryption keys
- **Granular Traffic Scoping**: Different inspection rules for different traffic types
- **Certificate Revocation Checking**: Configurable policies for certificate validation
- **Subject Alternative Names**: Support for multi-domain certificates
- **Production Protection**: All firewall protection settings enabled
- **Advanced Engine Options**: Strict order rule processing

## Architecture

```
Internet ←→ Network Firewall (Advanced TLS Inspection) ←→ VPC Resources
              ↓
    Advanced TLS Inspection Configuration
              ↓
    [Web Cert] + [API Cert] + [Corporate CA]
              ↓
         Customer KMS Key
```

## TLS Inspection Scenarios

### 1. Web Server Inbound Inspection
- **Certificate**: Multi-domain certificate with SAN
- **Ports**: 443, 8443
- **Sources**: Any external IP
- **Destinations**: Web server subnets (10.0.1.0/24, 10.0.2.0/24)

### 2. API Server Inbound Inspection
- **Certificate**: Dedicated API server certificate
- **Ports**: 443 only
- **Sources**: Restricted to specific IP ranges
- **Destinations**: API server subnet (10.0.10.0/24)

### 3. Corporate Outbound Inspection
- **Certificate**: Corporate Certificate Authority
- **Revocation Check**: REJECT revoked, PASS unknown
- **Sources**: Internal networks (RFC 1918)
- **Destinations**: Any external destination

## Security Features

### KMS Encryption
- **Customer-Managed Key**: Full control over encryption keys
- **Key Rotation**: Automatic annual key rotation enabled
- **Key Alias**: Friendly name for key management

### Certificate Management
- **DNS Validation**: Automated certificate validation
- **Lifecycle Management**: Proper certificate recreation handling
- **Tagging Strategy**: Organized certificate identification

### Revocation Checking
- **Configurable Actions**: PASS, DROP, or REJECT for different scenarios
- **OCSP/CRL Support**: Automatic certificate status validation
- **Fallback Policies**: Handle unknown certificate status appropriately

## Usage

1. **Configure Domains**: Update certificate domains in `variables.tf`
2. **Set IP Ranges**: Configure appropriate source/destination IP ranges
3. **Customize Policies**: Adjust revocation checking policies as needed
4. **Deploy Infrastructure**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Configuration Variables

### Certificate Domains
```hcl
web_server_domain     = "web.yourcompany.com"
web_server_san_domains = ["www.yourcompany.com", "app.yourcompany.com"]
api_server_domain     = "api.yourcompany.com"
corporate_ca_domain   = "ca.corp.yourcompany.com"
```

### Traffic Scoping
```hcl
web_server_destinations = [
  { address_definition = "10.0.1.0/24" },
  { address_definition = "10.0.2.0/24" }
]

api_allowed_sources = [
  { address_definition = "203.0.113.0/24" },  # Partner network
  { address_definition = "198.51.100.0/24" }  # Management network
]
```

### Revocation Policy
```hcl
revocation_policy = {
  revoked_action = "REJECT"  # Block revoked certificates
  unknown_action = "PASS"    # Allow unknown status (connectivity issues)
}
```

## Outputs

| Output | Description |
|--------|-------------|
| `firewall_arn` | Network Firewall ARN |
| `tls_inspection_configuration_arn` | TLS inspection configuration ARN |
| `kms_key_arn` | Customer KMS key ARN |
| `tls_inspection_certificate_authority` | CA certificate details |
| `tls_inspection_certificates` | Server certificate details |

## Best Practices

### Certificate Management
1. **Separate Certificates**: Use different certificates for different services
2. **Regular Rotation**: Implement certificate renewal processes
3. **Validation Monitoring**: Monitor certificate validation status

### Traffic Scoping
1. **Principle of Least Privilege**: Inspect only necessary traffic
2. **Performance Consideration**: Limit scope to reduce processing overhead
3. **Compliance Requirements**: Ensure inspection meets regulatory needs


<!-- BEGIN_TF_DOCS -->
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
| <a name="input_api_server_domain"></a> [api\_server\_domain](#input\_api\_server\_domain) | Domain for API server certificate | `string` | `"api.arc-poc.link"` | no |
| <a name="input_corporate_ca_domain"></a> [corporate\_ca\_domain](#input\_corporate\_ca\_domain) | Domain for corporate CA certificate | `string` | `"ca.corp.arc-poc.link"` | no |
| <a name="input_enable_protection"></a> [enable\_protection](#input\_enable\_protection) | Enable all protection settings | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | `"poc"` | no |
| <a name="input_external_sources"></a> [external\_sources](#input\_external\_sources) | External source IP ranges | <pre>list(object({<br/>    address_definition = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "address_definition": "0.0.0.0/0"<br/>  }<br/>]</pre> | no |
| <a name="input_internal_sources"></a> [internal\_sources](#input\_internal\_sources) | Internal source IP ranges for outbound traffic | <pre>list(object({<br/>    address_definition = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "address_definition": "10.0.0.0/8"<br/>  },<br/>  {<br/>    "address_definition": "172.16.0.0/12"<br/>  },<br/>  {<br/>    "address_definition": "192.168.0.0/16"<br/>  }<br/>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Network Firewall | `string` | `"advanced-tls-firewall"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for resources | `string` | `"arc"` | no |
| <a name="input_outbound_destinations"></a> [outbound\_destinations](#input\_outbound\_destinations) | Destination IP ranges for outbound inspection | <pre>list(object({<br/>    address_definition = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "address_definition": "0.0.0.0/0"<br/>  }<br/>]</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | `"us-east-1"` | no |
| <a name="input_revocation_policy"></a> [revocation\_policy](#input\_revocation\_policy) | Certificate revocation checking policy | <pre>object({<br/>    revoked_action = string<br/>    unknown_action = string<br/>  })</pre> | <pre>{<br/>  "revoked_action": "REJECT",<br/>  "unknown_action": "PASS"<br/>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | <pre>{<br/>  "Environment": "production",<br/>  "Owner": "security-team",<br/>  "Project": "advanced-tls-inspection"<br/>}</pre> | no |
| <a name="input_web_server_destinations"></a> [web\_server\_destinations](#input\_web\_server\_destinations) | Destination IP ranges for web server traffic | <pre>list(object({<br/>    address_definition = string<br/>  }))</pre> | <pre>[<br/>  {<br/>    "address_definition": "10.0.1.0/24"<br/>  },<br/>  {<br/>    "address_definition": "10.0.2.0/24"<br/>  }<br/>]</pre> | no |
| <a name="input_web_server_domain"></a> [web\_server\_domain](#input\_web\_server\_domain) | Primary domain for web server certificate | `string` | `"web.arc-poc.link"` | no |
| <a name="input_web_server_san_domains"></a> [web\_server\_san\_domains](#input\_web\_server\_san\_domains) | Subject Alternative Names for web server certificate | `list(string)` | <pre>[<br/>  "www.arc-poc.link",<br/>  "app.arc-poc.link"<br/>]</pre> | no |

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
<!-- END_TF_DOCS -->