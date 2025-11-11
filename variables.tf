variable "create_firewall" {
  description = "Controls whether the Network Firewall should be created"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of the Network Firewall"
  type        = string
}

variable "description" {
  description = "Description of the Network Firewall"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC ID where the firewall will be deployed"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "List of subnet IDs for firewall endpoints"
  type        = list(string)
  default     = []
}


variable "availability_zones" {
  description = "List of availability zone IDs for transit gateway-attached firewall"
  type        = list(string)
  default     = []
}

## Firewall Configurations
variable "firewall_config" {
  description = "Combined firewall settings"
  type = object({
    transit_gateway_id                  = optional(string)
    delete_protection                   = optional(bool, false)
    subnet_change_protection            = optional(bool, false)
    firewall_policy_change_protection   = optional(bool, false)
    availability_zone_change_protection = optional(bool, false)
    enabled_analysis_types              = optional(list(string), [])
    encryption_configuration = optional(object({
      type   = string
      key_id = optional(string)
    }))
    timeouts = optional(object({
      create = optional(string)
      update = optional(string)
      delete = optional(string)
    }))
  })
  default = {}
}

## Firewall Policy Configuration
variable "firewall_policy_config" {
  type = object({
    create      = optional(bool, false)
    arn         = optional(string)
    name        = optional(string)
    description = optional(string)
    encryption_configuration = optional(object({
      type   = string
      key_id = optional(string)
    }))
    stateless_default_actions          = optional(list(string), ["aws:forward_to_sfe"])
    stateless_fragment_default_actions = optional(list(string), ["aws:forward_to_sfe"])
    stateful_default_actions           = optional(list(string))
    stateful_engine_options = optional(object({
      rule_order              = optional(string, "DEFAULT_ACTION_ORDER")
      stream_exception_policy = optional(string, "DROP")
      flow_timeouts = optional(object({
        tcp_idle_timeout_seconds = optional(number, 350)
      }))
    }))
    policy_variables = optional(object({
      rule_variables = optional(map(object({
        definition = list(string)
      })), {})
    }), {})
    stateless_rule_groups = optional(list(object({
      resource_arn = string
      priority     = number
    })), [])
    stateful_rule_groups = optional(list(object({
      resource_arn           = string
      priority               = number
      deep_threat_inspection = optional(bool)
      override = optional(object({
        action = string
      }))
    })), [])
    stateless_custom_actions = optional(list(object({
      action_name = string
      action_definition = object({
        publish_metric_action = object({
          dimensions = list(object({
            value = string
          }))
        })
      })
    })), [])
    tls_inspection_configuration_arn    = optional(string)
    create_tls_inspection_configuration = optional(bool, false)
  })
  default = {}
}

## Logging Configuration
variable "logging_config" {
  description = <<EOT
List of logging destinations to configure.
Example:
[
  {
    log_type            = "FLOW"
    log_destination_type = "S3"
    log_destination_name = "firewall-logs-bucket"
  },
  {
    log_type            = "ALERT"
    log_destination_type = "CloudWatchLogs"
    log_destination_name = "firewall-alerts-loggroup"
  }
]
EOT
  type = object({
    enable             = optional(bool, true)
    log_retention_days = optional(number, 7)
    destinations = optional(list(object({
      log_type             = string
      log_destination_type = string # S3 | CloudWatchLogs | KinesisDataFirehose
      log_destination_name = string # bucket name or log group name
    })), [])
  })
  default = {}

  validation {
    condition = contains([
      1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653
    ], var.logging_config.log_retention_days)
    error_message = "Log retention days must be a valid CloudWatch retention period."
  }
}

## Firewall Resource Policy Configurations
variable "create_firewall_policy_resource_policy" {
  description = "Whether to create a resource policy for the firewall policy"
  type        = bool
  default     = false
}

variable "firewall_policy_resource_policy" {
  description = "Resource policy configuration for the firewall policy"
  type = object({
    statements = list(object({
      actions = list(string)
      effect  = string
      principals = object({
        aws = list(string)
      })
    }))
  })
  default = {
    statements = []
  }
}

## Rule Group Resource Policy Configurations
variable "create_rule_group_resource_policy" {
  description = "Whether to attach a resource policy to the Rule Group"
  type        = bool
  default     = false
}

variable "rule_group_resource_policy" {
  description = "IAM-style resource policy for Network Firewall Rule Group"
  type = object({
    statements = list(object({
      actions = list(string)
      effect  = string
      principals = object({
        aws = list(string)
      })
    }))
  })
  default = {
    statements = []
  }
}

## TLS Inspection Configuration
variable "tls_inspection_configuration" {
  description = "TLS inspection configuration"
  type = object({
    create      = optional(bool, false)
    name        = optional(string)
    description = optional(string)
    encryption_configuration = optional(object({
      key_id = optional(string)
      type   = optional(string, "AWS_OWNED_KMS_KEY")
    }))
    server_certificate_configurations = optional(list(object({
      certificate_authority_arn = optional(string)
      check_certificate_revocation_status = optional(object({
        revoked_status_action = optional(string, "REJECT")
        unknown_status_action = optional(string, "PASS")
      }))
      server_certificates = optional(list(object({
        resource_arn = string
      })), [])
      scopes = list(object({
        protocols = optional(list(number), [6])
        destinations = list(object({
          address_definition = string
        }))
        destination_ports = optional(list(object({
          from_port = number
          to_port   = optional(number)
        })), [])
        sources = optional(list(object({
          address_definition = string
        })), [])
        source_ports = optional(list(object({
          from_port = number
          to_port   = optional(number)
        })), [])
      }))
    })), [])
    timeouts = optional(object({
      create = optional(string)
      update = optional(string)
      delete = optional(string)
    }))
  })
  default = {}
}


## Rule Group Configuration
variable "rule_group_config" {
  description = "Complete rule group configuration in one object"
  type = object({
    create      = optional(bool, false)
    description = optional(string)
    capacity    = optional(number)
    type        = optional(string)
    encryption_configuration = optional(object({
      type   = string
      key_id = optional(string)
    }))
    rules = optional(string)
    rule_variables = optional(object({
      ip_sets = optional(list(object({
        key        = string
        definition = list(string)
      })))
      port_sets = optional(list(object({
        key        = string
        definition = list(string)
      })))
    }))
    rules_source = optional(object({
      rules_source_list = optional(list(object({
        generated_rules_type = string
        target_types         = list(string)
        targets              = list(string)
      })))
      rules_string = optional(string)
      stateful_rules = optional(list(object({
        action = string
        header = object({
          destination      = string
          destination_port = string
          direction        = string
          protocol         = string
          source           = string
          source_port      = string
        })
        rule_options = optional(list(object({
          keyword  = string
          settings = optional(list(string))
        })))
      })))
      stateless = optional(list(object({
        custom_actions = optional(list(object({
          action_name = string
          dimension   = string
        })))
        rules = list(object({
          priority = number
          actions  = list(string)
          match = object({
            destination = string
            destination_port = object({
              from = number
              to   = number
            })
            source = string
            source_port = object({
              from = number
              to   = number
            })
            protocols = optional(list(number))
          })
        }))
      })))
    }))
    stateful_rule_options = optional(object({
      rule_order = string
    }))
    reference_sets = optional(list(object({
      key = string
      arn = string
    })))
  })
  default = {}
}


## VPC Endpoint
variable "vpc_endpoint_association" {
  type = object({
    create      = optional(bool, false)
    description = optional(string)
    subnet_mappings = optional(list(object({
      subnet_id       = string
      ip_address_type = optional(string) # IPV4 or DUALSTACK
    })), [])
  })

  description = "Configuration for VPC Endpoint Association"
  default     = {}
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
