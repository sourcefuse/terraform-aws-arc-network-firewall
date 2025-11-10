##############################################
### Network Firewall
##############################################
resource "aws_networkfirewall_firewall" "this" {
  count = var.create_firewall ? 1 : 0

  name                = var.name
  firewall_policy_arn = local.firewall_policy_arn
  description         = var.description

  vpc_id = local.is_vpc_attached ? var.vpc_id : null

  dynamic "subnet_mapping" {
    for_each = local.subnet_mappings
    content {
      subnet_id       = subnet_mapping.value.subnet_id
      ip_address_type = null
    }
  }

  transit_gateway_id = local.is_tgw_attached ? var.firewall_config.transit_gateway_id : null

  dynamic "availability_zone_mapping" {
    for_each = local.az_mappings
    content {
      availability_zone_id = availability_zone_mapping.value.availability_zone_id
    }
  }

  # Combined object usage
  delete_protection                   = try(var.firewall_config.delete_protection, false)
  subnet_change_protection            = try(var.firewall_config.subnet_change_protection, false)
  firewall_policy_change_protection   = try(var.firewall_config.firewall_policy_change_protection, false)
  availability_zone_change_protection = try(var.firewall_config.availability_zone_change_protection, false)
  enabled_analysis_types              = try(var.firewall_config.enabled_analysis_types, [])

  dynamic "encryption_configuration" {
    for_each = try(var.firewall_config.encryption_configuration, null) != null ? [var.firewall_config.encryption_configuration] : []
    content {
      type   = encryption_configuration.value.type
      key_id = lookup(encryption_configuration.value, "key_id", null)
    }
  }

  tags = var.tags

  dynamic "timeouts" {
    for_each = try(var.firewall_config.timeouts, null) != null ? [var.firewall_config.timeouts] : []
    content {
      create = lookup(timeouts.value, "create", null)
      update = lookup(timeouts.value, "update", null)
      delete = lookup(timeouts.value, "delete", null)
    }
  }

  depends_on = [aws_networkfirewall_firewall_policy.this]
}


##########################################
### Network Firewall Policy
##########################################
resource "aws_networkfirewall_firewall_policy" "this" {
  count = var.create_firewall_policy ? 1 : 0

  name        = coalesce(try(var.firewall_policy_config.name, null), "${var.name}-policy")
  description = lookup(var.firewall_policy_config, "description", null)

  dynamic "encryption_configuration" {
    for_each = lookup(var.firewall_policy_config, "encryption_configuration", null) != null ? [var.firewall_policy_config.encryption_configuration] : []
    content {
      type   = encryption_configuration.value.type
      key_id = lookup(encryption_configuration.value, "key_id", null)
    }
  }

  firewall_policy {
    stateless_default_actions          = lookup(var.firewall_policy_config, "stateless_default_actions", ["aws:forward_to_sfe"])
    stateless_fragment_default_actions = lookup(var.firewall_policy_config, "stateless_fragment_default_actions", ["aws:forward_to_sfe"])
    stateful_default_actions           = lookup(var.firewall_policy_config, "stateful_default_actions", [])

    dynamic "stateful_engine_options" {
      for_each = lookup(var.firewall_policy_config, "stateful_engine_options", null) != null ? [var.firewall_policy_config.stateful_engine_options] : []
      content {
        rule_order              = lookup(stateful_engine_options.value, "rule_order", "DEFAULT_ACTION_ORDER")
        stream_exception_policy = lookup(stateful_engine_options.value, "stream_exception_policy", "DROP")

        dynamic "flow_timeouts" {
          for_each = lookup(stateful_engine_options.value, "flow_timeouts", null) != null ? [stateful_engine_options.value.flow_timeouts] : []
          content {
            tcp_idle_timeout_seconds = lookup(flow_timeouts.value, "tcp_idle_timeout_seconds", 350)
          }
        }
      }
    }

    dynamic "policy_variables" {
      for_each = length(lookup(var.firewall_policy_config.policy_variables, "rule_variables", {})) > 0 ? [var.firewall_policy_config.policy_variables] : []
      content {
        dynamic "rule_variables" {
          for_each = policy_variables.value.rule_variables
          content {
            key = rule_variables.key
            ip_set {
              definition = rule_variables.value.definition
            }
          }
        }
      }
    }

    dynamic "stateless_rule_group_reference" {
      for_each = lookup(var.firewall_policy_config, "stateless_rule_groups", [])
      content {
        priority     = stateless_rule_group_reference.value.priority
        resource_arn = stateless_rule_group_reference.value.resource_arn
      }
    }

    dynamic "stateful_rule_group_reference" {
      for_each = lookup(var.firewall_policy_config, "stateful_rule_groups", [])
      content {
        resource_arn           = stateful_rule_group_reference.value.resource_arn
        priority               = stateful_rule_group_reference.value.priority
        deep_threat_inspection = lookup(stateful_rule_group_reference.value, "deep_threat_inspection", null)

        dynamic "override" {
          for_each = lookup(stateful_rule_group_reference.value, "override", null) != null ? [stateful_rule_group_reference.value.override] : []
          content {
            action = override.value.action
          }
        }
      }
    }

    dynamic "stateless_custom_action" {
      for_each = lookup(var.firewall_policy_config, "stateless_custom_actions", [])
      content {
        action_name = stateless_custom_action.value.action_name
        action_definition {
          publish_metric_action {
            dynamic "dimension" {
              for_each = stateless_custom_action.value.action_definition.publish_metric_action.dimensions
              content {
                value = dimension.value.value
              }
            }
          }
        }
      }
    }

    tls_inspection_configuration_arn = lookup(var.firewall_policy_config, "create_tls_inspection_configuration", false) ? aws_networkfirewall_tls_inspection_configuration.this[0].arn : lookup(var.firewall_policy_config, "tls_inspection_configuration_arn", null)
  }

  tags = var.tags
}

## Create S3 Buckets if enabled
module "s3_firewall_logs" {
  source  = "sourcefuse/arc-s3/aws"
  version = "0.0.5"

  for_each = {
    for c in var.logging_config : c.log_destination_name => c
    if c.log_destination_type == "S3"
  }
  force_destroy = true

  name = each.key
  tags = var.tags
}

## Create CloudWatch Log Groups if enabled
resource "aws_cloudwatch_log_group" "firewall_logs" {
  for_each = {
    for c in var.logging_config : c.log_destination_name => c
    if c.log_destination_type == "CloudWatchLogs"
  }

  name              = "/aws/network-firewall/${each.key}"
  retention_in_days = var.log_retention_days
}

##############################################
### Network Firewall Logging Configuration
##############################################
resource "aws_networkfirewall_logging_configuration" "this" {
  count = var.enable_logging && length(var.logging_config) > 0 ? 1 : 0

  firewall_arn = aws_networkfirewall_firewall.this[0].arn


  logging_configuration {
    dynamic "log_destination_config" {
      for_each = var.logging_config
      content {
        log_type             = log_destination_config.value.log_type
        log_destination_type = log_destination_config.value.log_destination_type


        log_destination = (
          log_destination_config.value.log_destination_type == "S3" ?
          { bucketName = module.s3_firewall_logs[log_destination_config.value.log_destination_name].bucket_id } :

          log_destination_config.value.log_destination_type == "CloudWatchLogs" ?
          { logGroup = aws_cloudwatch_log_group.firewall_logs[log_destination_config.value.log_destination_name].name } :

          {}
        )
      }
    }
  }

  depends_on = [aws_networkfirewall_firewall.this]
}

##################################################
### Network Firewall VPC Endpoint  Configuration
##################################################
resource "aws_networkfirewall_vpc_endpoint_association" "this" {
  for_each = var.create_vpc_endpoint_association && var.vpc_endpoint_association != null ? { for idx, s in var.vpc_endpoint_association.subnet_mappings : idx => s } : {}


  firewall_arn = aws_networkfirewall_firewall.this[0].arn
  vpc_id       = local.is_vpc_attached ? var.vpc_id : null
  description  = lookup(var.vpc_endpoint_association, "description", null)
  subnet_mapping {
    subnet_id       = each.value.subnet_id
    ip_address_type = lookup(each.value, "ip_address_type", null)
  }
  tags = var.tags
}


########################################################
### Network Firewall Rule Group Configuration
########################################################
resource "aws_networkfirewall_rule_group" "this" {
  count       = var.create_rule_group ? 1 : 0
  name        = "${var.name}-rule-group"
  description = lookup(var.rule_group_config, "description", null)
  capacity    = lookup(var.rule_group_config, "capacity", 100)
  type        = lookup(var.rule_group_config, "type", "STATEFUL")

  dynamic "encryption_configuration" {
    for_each = lookup(var.rule_group_config, "encryption_configuration", null) != null ? [var.rule_group_config.encryption_configuration] : []
    content {
      type   = encryption_configuration.value.type
      key_id = lookup(encryption_configuration.value, "key_id", null)
    }
  }

  dynamic "rule_group" {
    for_each = lookup(var.rule_group_config, "rules", null) != null ? [] : [1] # use rule_group only if rules is null
    content {

      dynamic "rule_variables" {
        for_each = lookup(var.rule_group_config, "rule_variables", null) != null ? [var.rule_group_config.rule_variables] : []
        content {

          dynamic "ip_sets" {
            for_each = lookup(rule_variables.value, "ip_sets", [])
            content {
              key = ip_sets.value.key
              ip_set {
                definition = ip_sets.value.definition
              }
            }
          }

          dynamic "port_sets" {
            for_each = lookup(rule_variables.value, "port_sets", [])
            content {
              key = port_sets.value.key
              port_set {
                definition = port_sets.value.definition
              }
            }
          }
        }
      }

      dynamic "rules_source" {
        for_each = lookup(var.rule_group_config, "rules_source", null) != null ? [var.rule_group_config.rules_source] : []
        content {

          dynamic "rules_source_list" {
            for_each = coalesce(lookup(rules_source.value, "rules_source_list", []), [])
            content {
              generated_rules_type = rules_source_list.value.generated_rules_type
              target_types         = rules_source_list.value.target_types
              targets              = rules_source_list.value.targets
            }
          }

          rules_string = lookup(rules_source.value, "rules_string", null)

          dynamic "stateful_rule" {
            for_each = coalesce(lookup(rules_source.value, "stateful_rules", []), [])
            content {
              action = stateful_rule.value.action
              header {
                destination      = stateful_rule.value.header.destination
                destination_port = stateful_rule.value.header.destination_port
                direction        = stateful_rule.value.header.direction
                protocol         = stateful_rule.value.header.protocol
                source           = stateful_rule.value.header.source
                source_port      = stateful_rule.value.header.source_port
              }
              dynamic "rule_option" {
                for_each = lookup(stateful_rule.value, "rule_options", [])
                content {
                  keyword  = rule_option.value.keyword
                  settings = lookup(rule_option.value, "settings", null)
                }
              }
            }
          }

          dynamic "stateless_rules_and_custom_actions" {
            for_each = coalesce(lookup(rules_source.value, "stateless", []), [])
            content {
              dynamic "custom_action" {
                for_each = coalesce(lookup(stateless_rules_and_custom_actions.value, "custom_actions", []), [])
                content {
                  action_name = custom_action.value.action_name
                  action_definition {
                    publish_metric_action {
                      dimension {
                        value = custom_action.value.dimension
                      }
                    }
                  }
                }
              }

              dynamic "stateless_rule" {
                for_each = coalesce(lookup(stateless_rules_and_custom_actions.value, "rules", []), [])
                content {
                  priority = stateless_rule.value.priority
                  rule_definition {
                    actions = stateless_rule.value.actions
                    match_attributes {
                      destination {
                        address_definition = stateless_rule.value.match.destination
                      }
                      destination_port {
                        from_port = stateless_rule.value.match.destination_port.from
                        to_port   = stateless_rule.value.match.destination_port.to
                      }
                      source {
                        address_definition = stateless_rule.value.match.source
                      }
                      source_port {
                        from_port = stateless_rule.value.match.source_port.from
                        to_port   = stateless_rule.value.match.source_port.to
                      }
                      protocols = lookup(stateless_rule.value.match, "protocols", null)
                    }
                  }
                }
              }
            }
          }
        }
      }

      dynamic "stateful_rule_options" {
        for_each = lookup(var.rule_group_config, "stateful_rule_options", null) != null ? [var.rule_group_config.stateful_rule_options] : []
        content {
          rule_order = stateful_rule_options.value.rule_order
        }
      }

      dynamic "reference_sets" {
        for_each = coalesce(lookup(var.rule_group_config, "reference_sets", []), [])
        content {
          ip_set_references {
            key = reference_sets.value.key
            ip_set_reference {
              reference_arn = reference_sets.value.arn
            }
          }
        }
      }
    }
  }

  rules = lookup(var.rule_group_config, "rules", null)

  tags = var.tags
}

###########################################################
### Network Firewall Resource Policy for Firewall Policy
###########################################################
resource "aws_networkfirewall_resource_policy" "firewall_policy" {
  count = var.create_firewall_policy && var.create_firewall_policy_resource_policy ? 1 : 0

  resource_arn = aws_networkfirewall_firewall_policy.this[0].arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      for statement in var.firewall_policy_resource_policy.statements : {
        Effect = statement.effect
        Action = statement.actions

        Resource = aws_networkfirewall_firewall_policy.this[0].arn
        Principal = {
          AWS = statement.principals.aws
        }
      }
    ]
  })

  depends_on = [aws_networkfirewall_firewall_policy.this]
}

###########################################################
### Network Firewall Resource Policy for Rule Group
###########################################################
resource "aws_networkfirewall_resource_policy" "example" {
  count        = var.create_rule_group && var.create_rule_group_resource_policy ? 1 : 0
  resource_arn = aws_networkfirewall_rule_group.this[0].arn
  # policy's Action element must include all of the following operations
  policy = jsonencode({
    Statement = [
      for s in var.rule_group_resource_policy.statements : {
        Action   = s.actions
        Effect   = s.effect
        Resource = aws_networkfirewall_rule_group.this[0].arn
        Principal = {
          AWS = s.principals.aws
        }
      }
    ]
    Version = "2012-10-17"
  })
  depends_on = [aws_networkfirewall_rule_group.this]
}


###############################################
### TLS Inspection Configuration
###############################################
resource "aws_networkfirewall_tls_inspection_configuration" "this" {
  count = var.create_tls_inspection_configuration ? 1 : 0

  name        = coalesce(var.tls_inspection_configuration.name, "${var.name}-tls-inspection")
  description = var.tls_inspection_configuration.description

  dynamic "encryption_configuration" {
    for_each = var.tls_inspection_configuration.encryption_configuration != null ? [var.tls_inspection_configuration.encryption_configuration] : []
    content {
      key_id = encryption_configuration.value.key_id
      type   = encryption_configuration.value.type
    }
  }

  tls_inspection_configuration {
    dynamic "server_certificate_configuration" {
      for_each = var.tls_inspection_configuration.server_certificate_configurations
      content {
        certificate_authority_arn = server_certificate_configuration.value.certificate_authority_arn

        dynamic "check_certificate_revocation_status" {
          for_each = server_certificate_configuration.value.check_certificate_revocation_status != null ? [server_certificate_configuration.value.check_certificate_revocation_status] : []
          content {
            revoked_status_action = check_certificate_revocation_status.value.revoked_status_action
            unknown_status_action = check_certificate_revocation_status.value.unknown_status_action
          }
        }

        dynamic "server_certificate" {
          for_each = server_certificate_configuration.value.server_certificates
          content {
            resource_arn = server_certificate.value.resource_arn
          }
        }

        dynamic "scope" {
          for_each = server_certificate_configuration.value.scopes
          content {
            protocols = scope.value.protocols

            dynamic "destination" {
              for_each = scope.value.destinations
              content {
                address_definition = destination.value.address_definition
              }
            }

            dynamic "destination_ports" {
              for_each = scope.value.destination_ports
              content {
                from_port = destination_ports.value.from_port
                to_port   = destination_ports.value.to_port
              }
            }

            dynamic "source" {
              for_each = scope.value.sources
              content {
                address_definition = source.value.address_definition
              }
            }

            dynamic "source_ports" {
              for_each = scope.value.source_ports
              content {
                from_port = source_ports.value.from_port
                to_port   = source_ports.value.to_port
              }
            }
          }
        }
      }
    }
  }

  dynamic "timeouts" {
    for_each = var.tls_inspection_configuration.timeouts != null ? [var.tls_inspection_configuration.timeouts] : []
    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }

  tags = var.tags
}
