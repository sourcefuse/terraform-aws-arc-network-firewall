data "aws_vpc" "default" {
  filter {
    name   = "tag:Name"
    values = ["${var.namespace}-${var.environment}-vpc"]
  }
}

data "aws_subnets" "public" {
  filter {
    name = "tag:Name"
    values = [
      "${var.namespace}-${var.environment}-public-subnet-public-${var.region}a",
      "${var.namespace}-${var.environment}-public-subnet-public-${var.region}b"
    ]
  }
}


data "aws_ssm_parameter" "inbound_cert" {
  name = "/tls/inbound/certificate_arn"
}

data "aws_ssm_parameter" "outbound_ca" {
  name = "/tls/outbound/ca_arn"
}
