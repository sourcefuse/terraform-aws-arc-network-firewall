variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "poc"
}

variable "namespace" {
  description = "Namespace for resources"
  type        = string
  default     = "arc"
}

variable "name" {
  description = "Name of the Network Firewall"
  type        = string
  default     = "firewall-with-rule-group-policies"
}

variable "trusted_account_arn" {
  description = "ARN of the trusted AWS account for resource policy"
  type        = string
  default     = "arn:aws:iam::884360309640:root"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "example"
    Project     = "network-firewall"
  }
}
