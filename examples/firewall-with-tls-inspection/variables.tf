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
  default     = "firewall-with-tls-inspection"
}