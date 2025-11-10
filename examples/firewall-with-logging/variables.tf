################################################################################
## shared
################################################################################
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Name of the environment, i.e. dev, stage, prod"
  default     = "poc"
}

variable "namespace" {
  type        = string
  default     = "arc"
  description = "Namespace of the project, i.e. arc"
}


variable "firewall_name" {
  description = "Name of the Network Firewall"
  type        = string
  default     = "logging-network-firewall"
}

variable "delete_protection" {
  description = "Enable deletion protection for the firewall"
  type        = bool
  default     = false
}

variable "log_retention_days" {
  description = "CloudWatch log retention period in days"
  type        = number
  default     = 7
  validation {
    condition = contains([
      1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653
    ], var.log_retention_days)
    error_message = "Log retention days must be a valid CloudWatch retention period."
  }
}

variable "enable_kinesis_firehose" {
  description = "Enable Kinesis Data Firehose for log delivery"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "demo"
    Project     = "network-firewall-logging"
  }
}
