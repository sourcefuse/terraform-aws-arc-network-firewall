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

# Network Firewall with TLS inspection
module "network_firewall" {
  source = "../../"

  name       = var.name
  vpc_id     = data.aws_vpc.default.id
  subnet_ids = slice(data.aws_subnets.public.ids, 0, min(2, length(data.aws_subnets.public.ids)))

  create_firewall = false

  firewall_policy_config = {
    create = false
  }

  # TLS Inspection Configuration
  tls_inspection_configuration = {
    create      = true
    name        = "${var.name}-tls-inspection"
    description = "TLS inspection for inbound and outbound traffic"

    encryption_configuration = {
      type   = "AWS_OWNED_KMS_KEY"
      key_id = "AWS_OWNED_KMS_KEY"
    }

    server_certificate_configurations = [
      {
        # Inbound certificate for decrypting inbound traffic
        server_certificates = [
          {
            resource_arn = data.aws_ssm_parameter.inbound_cert.value
          }
        ]

        # Outbound certificate authority to re-sign decrypted traffic
        certificate_authority_arn = data.aws_ssm_parameter.outbound_ca.value
        # Revocation checks for outbound
        check_certificate_revocation_status = {
          revoked_status_action = "REJECT"
          unknown_status_action = "PASS"
        }

        # Multiple scopes in same configuration
        scopes = [
          # ---------- Inbound Traffic ----------
          {
            protocols = [6]
            destinations = [
              {
                address_definition = "0.0.0.0/0"
              }
            ]
            destination_ports = [
              {
                from_port = 443
                to_port   = 443
              }
            ]
            sources = [
              {
                address_definition = "0.0.0.0/0"
              }
            ]
            source_ports = [
              {
                from_port = 0
                to_port   = 65535
              }
            ]
          },

          # ---------- Outbound Traffic ----------
          {
            protocols = [6]
            destinations = [
              {
                address_definition = "0.0.0.0/0"
              }
            ]
            destination_ports = [
              {
                from_port = 443
                to_port   = 443
              }
            ]
            sources = [
              {
                address_definition = "10.0.0.0/8"
              }
            ]
            source_ports = [
              {
                from_port = 0
                to_port   = 65535
              }
            ]
          }
        ]
      }
    ]
  }

  tags = module.tags.tags
}
