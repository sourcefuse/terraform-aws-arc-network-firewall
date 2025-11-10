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

## SourceFuse Modules Used

### VPC Module
- **Source**: [terraform-aws-arc-network](https://github.com/sourcefuse/terraform-aws-arc-network)
- **Features**: VPC, subnets, NAT gateways, route tables
- **Version**: ~> 2.0

### Transit Gateway Module  
- **Source**: [terraform-aws-arc-transit-gateway](https://github.com/sourcefuse/terraform-aws-arc-transit-gateway)
- **Features**: Transit Gateway, VPC attachments, route tables
- **Version**: ~> 0.0.1

## Usage

1. **Configure Variables**: Update `example.auto.tfvars` or provide your own:
   ```hcl
   namespace     = "your-namespace"
   environment   = "your-environment"
   firewall_name = "your-firewall-name"
   vpc_cidr      = "10.1.0.0/16"
   ```

2. **Deploy Infrastructure**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Configuration

### VPC Configuration
The SourceFuse VPC module creates:
- VPC with specified CIDR block
- Public and private subnets across multiple AZs
- Internet Gateway and NAT Gateway
- Route tables with appropriate routes

### Transit Gateway Configuration
The SourceFuse Transit Gateway module creates:
- Transit Gateway with default route table settings
- VPC attachment to the created VPC
- Route propagation and association

### Network Firewall Configuration
- Attached to Transit Gateway (not VPC subnets)
- Strict order rule processing
- Default drop action for unmatched traffic
- Protection settings enabled

## Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|:--------:|
| `aws_region` | AWS region for resources | `us-east-1` | no |
| `namespace` | Namespace for infrastructure | `arc` | no |
| `environment` | Environment name | `demo` | no |
| `firewall_name` | Name of the Network Firewall | `tgw-network-firewall` | no |
| `vpc_cidr` | CIDR block for the VPC | `10.1.0.0/16` | no |
| `delete_protection` | Enable deletion protection | `false` | no |
| `tags` | Tags to apply to resources | `{}` | no |

## Outputs

| Output | Description |
|--------|-------------|
| `firewall_arn` | ARN of the Network Firewall |
| `firewall_name` | Name of the Network Firewall |
| `firewall_policy_arn` | ARN of the Firewall Policy |
| `transit_gateway_id` | ID of the Transit Gateway |
| `transit_gateway_arn` | ARN of the Transit Gateway |
| `vpc_id` | ID of the VPC |
| `vpc_cidr_block` | CIDR block of the VPC |
| `private_subnet_ids` | IDs of the private subnets |
| `public_subnet_ids` | IDs of the public subnets |
| `tgw_vpc_attachment_ids` | IDs of the Transit Gateway VPC attachments |

## Benefits of Using SourceFuse Modules

### Production-Ready
- Battle-tested modules used in production environments
- Comprehensive tagging and naming conventions
- Security best practices built-in

### Standardization
- Consistent infrastructure patterns across projects
- Reduced configuration complexity
- Standardized outputs and interfaces

### Maintenance
- Regular updates and security patches
- Community-driven improvements
- Professional support available

## Extending the Example

### Adding More VPCs
To attach additional VPCs to the Transit Gateway:

```hcl
module "additional_vpc" {
  source  = "sourcefuse/arc-network/aws"
  version = "~> 2.0"

  namespace   = var.namespace
  environment = "${var.environment}-additional"
  
  vpc_cidr_block = "10.2.0.0/16"
  # ... other configuration
}

# Update Transit Gateway module
module "transit_gateway" {
  # ... existing configuration
  
  vpc_attachments = [
    {
      vpc_id     = module.vpc.vpc_id
      subnet_ids = module.vpc.private_subnet_ids
    },
    {
      vpc_id     = module.additional_vpc.vpc_id
      subnet_ids = module.additional_vpc.private_subnet_ids
    }
  ]
}
```

### Custom Route Tables
Add custom routing logic through the Transit Gateway:

```hcl
# Custom route table for specific traffic flows
resource "aws_ec2_transit_gateway_route_table" "custom" {
  transit_gateway_id = module.transit_gateway.transit_gateway_id
  
  tags = merge(var.tags, {
    Name = "${var.firewall_name}-custom-rt"
  })
}
```

## Security Considerations

1. **Network Segmentation**: Use Transit Gateway route tables for traffic isolation
2. **Firewall Rules**: Configure appropriate stateful and stateless rules
3. **Logging**: Enable comprehensive logging for security monitoring
4. **Access Control**: Implement least-privilege IAM policies

## Cost Optimization

1. **Right-sizing**: Choose appropriate firewall capacity
2. **NAT Gateway**: SourceFuse module allows single NAT gateway option
3. **Data Transfer**: Monitor cross-AZ data transfer costs
4. **Resource Tagging**: Use consistent tagging for cost allocation

## Troubleshooting

### Common Issues
1. **Module Versions**: Ensure compatible versions of SourceFuse modules
2. **CIDR Conflicts**: Avoid overlapping CIDR blocks
3. **Route Propagation**: Verify Transit Gateway route propagation settings

### Validation
```bash
# Validate configuration
terraform validate

# Check module sources
terraform get -update

# Plan with detailed output
terraform plan -detailed-exitcode
```

## Support

- **SourceFuse Modules**: [GitHub Issues](https://github.com/sourcefuse)
- **AWS Network Firewall**: AWS Support or documentation
- **Terraform**: HashiCorp documentation and community
