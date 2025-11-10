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
  default     = "advanced-tls-firewall"
}

# Certificate domains
variable "web_server_domain" {
  description = "Primary domain for web server certificate"
  type        = string
  default     = "web.arc-poc.link"
}

variable "web_server_san_domains" {
  description = "Subject Alternative Names for web server certificate"
  type        = list(string)
  default     = ["www.arc-poc.link", "app.arc-poc.link"]
}

variable "api_server_domain" {
  description = "Domain for API server certificate"
  type        = string
  default     = "api.arc-poc.link"
}

variable "corporate_ca_domain" {
  description = "Domain for corporate CA certificate"
  type        = string
  default     = "ca.corp.arc-poc.link"
}

# Traffic scoping
variable "web_server_destinations" {
  description = "Destination IP ranges for web server traffic"
  type = list(object({
    address_definition = string
  }))
  default = [
    { address_definition = "10.0.1.0/24" },
    { address_definition = "10.0.2.0/24" }
  ]
}

variable "api_server_destinations" {
  description = "Destination IP ranges for API server traffic"
  type = list(object({
    address_definition = string
  }))
  default = [
    { address_definition = "10.0.10.0/24" }
  ]
}

variable "outbound_destinations" {
  description = "Destination IP ranges for outbound inspection"
  type = list(object({
    address_definition = string
  }))
  default = [
    { address_definition = "0.0.0.0/0" }
  ]
}

variable "external_sources" {
  description = "External source IP ranges"
  type = list(object({
    address_definition = string
  }))
  default = [
    { address_definition = "0.0.0.0/0" }
  ]
}

variable "api_allowed_sources" {
  description = "Allowed source IP ranges for API access"
  type = list(object({
    address_definition = string
  }))
  default = [
    { address_definition = "203.0.113.0/24" },
    { address_definition = "198.51.100.0/24" }
  ]
}

variable "internal_sources" {
  description = "Internal source IP ranges for outbound traffic"
  type = list(object({
    address_definition = string
  }))
  default = [
    { address_definition = "10.0.0.0/8" },
    { address_definition = "172.16.0.0/12" },
    { address_definition = "192.168.0.0/16" }
  ]
}

# Certificate revocation policy
variable "revocation_policy" {
  description = "Certificate revocation checking policy"
  type = object({
    revoked_action = string
    unknown_action = string
  })
  default = {
    revoked_action = "REJECT"
    unknown_action = "PASS"
  }
  validation {
    condition     = contains(["PASS", "DROP", "REJECT"], var.revocation_policy.revoked_action)
    error_message = "Revoked action must be PASS, DROP, or REJECT."
  }
  validation {
    condition     = contains(["PASS", "DROP", "REJECT"], var.revocation_policy.unknown_action)
    error_message = "Unknown action must be PASS, DROP, or REJECT."
  }
}

variable "enable_protection" {
  description = "Enable all protection settings"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default = {
    Environment = "production"
    Project     = "advanced-tls-inspection"
    Owner       = "security-team"
  }
}
