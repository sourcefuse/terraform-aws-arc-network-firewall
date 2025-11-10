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

### AWS Managed Rules
- Common Rule Set for threat detection
- Configured with ALERT override (instead of DROP)

## Usage

1. Update the variables in `example.auto.tfvars` as needed
2. Initialize and apply the configuration:

```bash
terraform init
terraform plan
terraform apply
```

## Configuration Details

### Engine Options
- **Rule Order**: STRICT_ORDER for deterministic evaluation
- **Stream Exception Policy**: DROP for broken connections
- **TCP Idle Timeout**: 300 seconds

### Policy Variables
- **HOME_NET**: Defined as RFC 1918 private networks

### Protection Settings
- All protection mechanisms are enabled for production-like security

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| aws_region | AWS region for resources | string | us-east-1 |
| firewall_name | Name of the Network Firewall | string | advanced-network-firewall |
| delete_protection | Enable deletion protection | bool | false |
| tags | Tags to apply to resources | map(string) | See variables.tf |

## Outputs

| Name | Description |
|------|-------------|
| firewall_arn | ARN of the Network Firewall |
| firewall_name | Name of the Network Firewall |
| firewall_policy_arn | ARN of the Firewall Policy |
| firewall_endpoint_ids | Map of endpoint IDs by AZ |
| stateless_rule_group_arn | ARN of custom stateless rule group |
| stateful_rule_group_arn | ARN of custom stateful rule group |
| vpc_id | VPC ID where firewall is deployed |

## Suricata Rule Syntax

The stateful rules use Suricata format:
- `pass`: Allow the traffic
- `drop`: Block the traffic
- `http.host`: Match HTTP Host header
- `tls.sni`: Match TLS Server Name Indication
- `flow:to_server,established`: Match established connections to server

## Clean Up

```bash
terraform destroy
```

**Note**: Rule groups must be deleted before the firewall policy that references them.
