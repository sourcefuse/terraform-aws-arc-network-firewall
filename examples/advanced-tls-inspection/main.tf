################################################################################
## Tags
################################################################################
module "tags" {
  source  = "sourcefuse/arc-tags/aws"
  version = "1.2.3"

  environment = var.environment
  project     = var.namespace

  extra_tags = {
    RepoName = "terraform-aws-arc-network-firewall"
  }
}


# Network Firewall with advanced TLS inspection
module "network_firewall" {
  source = "../../"

  name                   = var.name
  vpc_id                 = data.aws_vpc.default.id
  subnet_ids             = slice(data.aws_subnets.public.ids, 0, min(2, length(data.aws_subnets.public.ids)))
  create_firewall        = true
  create_firewall_policy = true

  # Advanced stateful engine options

  firewall_policy_config = {
    name        = "${var.name}-firewall-policy"
    description = "Advanced policy with stateful and stateless rules"



    stateful_engine_options = {
      rule_order              = "STRICT_ORDER"
      stream_exception_policy = "DROP"
      flow_timeouts = {
        tcp_idle_timeout_seconds = 300
      }
    }
  }

  # TLS Inspection Configuration with customer KMS
  create_tls_inspection_configuration = true
  tls_inspection_configuration = {
    name        = "${var.name}-advanced-tls-inspection"
    description = "Advanced TLS inspection with multiple certificates and custom KMS encryption"

    encryption_configuration = {
      type   = "CUSTOMER_KMS"
      key_id = aws_kms_key.tls_inspection.arn
    }

    server_certificate_configurations = [
      {
        server_certificates = [
          # Web and API server certificates together
          {
            resource_arn = data.aws_ssm_parameter.inbound_cert.value
          },

        ]

        # Combine all scopes
        scopes = concat(
          [
            # Web server inbound inspection
            {
              protocols    = [6]
              destinations = var.web_server_destinations
              destination_ports = [
                { from_port = 443, to_port = 443 },
                { from_port = 8443, to_port = 8443 }
              ]
              sources = var.external_sources
              source_ports = [
                { from_port = 0, to_port = 65535 }
              ]
            }
          ],
          [
            # API server inbound inspection
            {
              protocols    = [6]
              destinations = var.api_server_destinations
              destination_ports = [
                { from_port = 443, to_port = 443 }
              ]
              sources = var.api_allowed_sources
              source_ports = [
                { from_port = 0, to_port = 65535 }
              ]
            }
          ],
          [
            # Corporate outbound inspection (CA)
            {
              protocols    = [6]
              destinations = var.outbound_destinations
              destination_ports = [
                { from_port = 443, to_port = 443 },
                { from_port = 8443, to_port = 8443 }
              ]
              sources = var.internal_sources
              source_ports = [
                { from_port = 0, to_port = 65535 }
              ]
            }
          ]
        )

        # Optional CA + revocation checking
        certificate_authority_arn = data.aws_ssm_parameter.outbound_ca.value
        check_certificate_revocation_status = {
          revoked_status_action = var.revocation_policy.revoked_action
          unknown_status_action = var.revocation_policy.unknown_action
        }
      }
    ]

    timeouts = {
      create = "45m"
      update = "45m"
      delete = "45m"
    }
  }

  # Protection settings
  firewall_config = {
    delete_protection                   = var.enable_protection
    subnet_change_protection            = var.enable_protection
    firewall_policy_change_protection   = var.enable_protection
    availability_zone_change_protection = var.enable_protection
  }

  tags = module.tags.tags
}


# KMS Key for TLS inspection encryption
resource "aws_kms_key" "tls_inspection" {
  description             = "KMS key for Network Firewall TLS inspection configuration"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(module.tags.tags, {
    Name = "${var.name}-tls-inspection-key"
  })
}

resource "aws_kms_alias" "tls_inspection" {
  name          = "alias/${var.name}-tls-inspection"
  target_key_id = aws_kms_key.tls_inspection.key_id
}