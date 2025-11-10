# Network Firewall with Comprehensive Logging

This example demonstrates how to create an AWS Network Firewall with comprehensive logging configuration, including CloudWatch Logs, S3, and optional Kinesis Data Firehose integration.

## What This Example Creates

- A Network Firewall with logging enabled
- CloudWatch Log Groups for ALERT and FLOW logs
- S3 bucket for TLS logs with encryption and versioning
- Optional Kinesis Data Firehose delivery stream
- IAM roles and policies for log delivery

## Features Demonstrated

- **CloudWatch Logs Integration**: Real-time log streaming
- **S3 Log Storage**: Long-term log archival with encryption
- **Kinesis Data Firehose**: Stream processing and delivery
- **Multiple Log Types**: ALERT, FLOW, and TLS logs
- **Security Best Practices**: Encrypted storage, least-privilege IAM
- **Log Retention Management**: Configurable retention periods

## Logging Configuration

### Log Types
- **ALERT**: Security events and rule matches
- **FLOW**: Network traffic flow information
- **TLS**: TLS connection metadata

### Log Destinations
- **CloudWatch Logs**: ALERT and FLOW logs for real-time monitoring
- **S3**: TLS logs for long-term storage and analysis
- **Kinesis Data Firehose**: Optional stream processing (FLOW logs)

### Security Features
- S3 bucket encryption with AES256
- S3 bucket versioning enabled
- Public access blocked on S3 bucket
- Least-privilege IAM policies
- Configurable log retention periods

## Usage

1. Update the variables in `example.auto.tfvars` as needed
2. Initialize and apply the configuration:

```bash
terraform init
terraform plan
terraform apply
```

### Enable Kinesis Data Firehose (Optional)

To enable Kinesis Data Firehose for additional log processing:

```hcl
enable_kinesis_firehose = true
```

## Configuration Details

### CloudWatch Log Groups
- Retention period: Configurable (default: 7 days)
- Log group names: `/aws/networkfirewall/{firewall-name}/{log-type}`

### S3 Bucket
- Encryption: AES256 server-side encryption
- Versioning: Enabled for data protection
- Public access: Completely blocked
- Prefix: `tls-logs/` for TLS logs

### Kinesis Data Firehose (Optional)
- Buffer size: 5 MB
- Buffer interval: 300 seconds
- Compression: GZIP
- Destination: S3 with `firehose-logs/` prefix

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| aws_region | AWS region for resources | string | us-east-1 |
| firewall_name | Name of the Network Firewall | string | logging-network-firewall |
| delete_protection | Enable deletion protection | bool | false |
| log_retention_days | CloudWatch log retention period | number | 7 |
| enable_kinesis_firehose | Enable Kinesis Data Firehose | bool | false |
| tags | Tags to apply to resources | map(string) | See variables.tf |

## Outputs

| Name | Description |
|------|-------------|
| firewall_arn | ARN of the Network Firewall |
| firewall_name | Name of the Network Firewall |
| firewall_policy_arn | ARN of the Firewall Policy |
| cloudwatch_log_group_alert | CloudWatch Log Group for ALERT logs |
| cloudwatch_log_group_flow | CloudWatch Log Group for FLOW logs |
| s3_bucket_logs | S3 bucket for TLS logs |
| kinesis_firehose_stream | Kinesis Data Firehose stream name |
| logging_configuration_id | Logging configuration ID |

## Monitoring and Analysis

### CloudWatch Logs Insights Queries

Query ALERT logs for security events:
```sql
fields @timestamp, alert.action, alert.signature
| filter alert.action = "blocked"
| sort @timestamp desc
```

Query FLOW logs for traffic patterns:
```sql
fields @timestamp, netflow.srcaddr, netflow.dstaddr, netflow.srcport, netflow.dstport
| stats count() by netflow.dstport
| sort count desc
```

### S3 Log Analysis
TLS logs in S3 can be analyzed using:
- Amazon Athena for SQL queries
- AWS Glue for ETL processing
- Third-party SIEM tools

## Cost Considerations

- CloudWatch Logs: Charged per GB ingested and stored
- S3 Storage: Standard storage rates apply
- Kinesis Data Firehose: Charged per GB processed
- Consider log retention periods to manage costs

## Clean Up

```bash
terraform destroy
```

**Note**: S3 bucket is configured with `force_destroy = true` for easy cleanup in demo environments. Remove this in production.
