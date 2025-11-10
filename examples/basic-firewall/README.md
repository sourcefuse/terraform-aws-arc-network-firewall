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

## Usage

1. Update the variables in `example.auto.tfvars` as needed
2. Initialize and apply the configuration:

```bash
terraform init
terraform plan
terraform apply
```

## Configuration

The example uses the following default settings:

- **Default Actions**: Forward to stateful engine (`aws:forward_to_sfe`)
- **Fragment Actions**: Forward to stateful engine (`aws:forward_to_sfe`)
- **VPC**: Uses the default VPC in the region
- **Subnets**: Uses up to 2 available subnets from the default VPC

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| aws_region | AWS region for resources | string | us-east-1 |
| firewall_name | Name of the Network Firewall | string | basic-network-firewall |
| delete_protection | Enable deletion protection | bool | false |
| tags | Tags to apply to resources | map(string) | See variables.tf |

## Outputs

| Name | Description |
|------|-------------|
| firewall_arn | ARN of the Network Firewall |
| firewall_name | Name of the Network Firewall |
| firewall_policy_arn | ARN of the Firewall Policy |
| firewall_endpoint_ids | Map of endpoint IDs by AZ |
| vpc_id | VPC ID where firewall is deployed |

## Clean Up

```bash
terraform destroy
```
