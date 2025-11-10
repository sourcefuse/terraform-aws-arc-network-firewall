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

## Usage

1. Update domain names in `variables.tf` or provide them via tfvars:
   ```hcl
   inbound_domain_name    = "your-inbound-domain.com"
   outbound_ca_domain_name = "your-ca-domain.com"
   ```

2. Run Terraform commands:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Certificate Requirements

- **Inbound Certificate**: Must be a valid SSL/TLS server certificate in ACM
- **Outbound CA Certificate**: Must be a Certificate Authority certificate in ACM
- **Validation**: Both certificates use DNS validation method

## Security Considerations

1. **Certificate Management**: Ensure certificates are properly validated and renewed
2. **Revocation Checking**: Configure appropriate actions for revoked/unknown certificates
3. **Scope Configuration**: Limit inspection to necessary traffic patterns
4. **Encryption**: Uses AWS-owned KMS keys for configuration encryption

## Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `inbound_domain_name` | Domain for inbound certificate | `inbound.example.com` |
| `outbound_ca_domain_name` | Domain for CA certificate | `ca.example.com` |
| `region` | AWS region | `us-east-1` |
| `environment` | Environment name | `poc` |
| `namespace` | Resource namespace | `arc` |

## Outputs

- `firewall_arn`: ARN of the Network Firewall
- `tls_inspection_configuration_arn`: ARN of the TLS inspection configuration
- `inbound_certificate_arn`: ARN of the inbound certificate
- `outbound_ca_certificate_arn`: ARN of the outbound CA certificate

## Important Notes

1. **Certificate Validation**: You must complete DNS validation for ACM certificates
2. **Traffic Impact**: TLS inspection may impact network performance
3. **Compliance**: Ensure TLS inspection complies with your security policies
4. **Cost**: TLS inspection incurs additional charges based on processed traffic
