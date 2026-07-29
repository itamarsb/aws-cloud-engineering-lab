resource "aws_security_group" "ec2_ssm" {
  name        = "${local.resource_prefix}-sg"
  description = "No inbound access. Administrative sessions use AWS Systems Manager."
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "${local.resource_prefix}-sg"
  }
}

resource "aws_vpc_security_group_egress_rule" "https_and_updates" {
  security_group_id = aws_security_group.ec2_ssm.id
  description       = "Allow outbound IPv4 connectivity to AWS APIs and operating-system repositories."
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}

