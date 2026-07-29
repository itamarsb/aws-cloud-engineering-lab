resource "aws_instance" "lab01" {
  ami           = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type = var.instance_type

  subnet_id                   = sort(data.aws_subnets.default.ids)[0]
  associate_public_ip_address = var.associate_public_ip
  vpc_security_group_ids      = [aws_security_group.ec2_ssm.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm.name

  # No key_name is configured. Administrative access uses Session Manager.

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    encrypted             = true
    delete_on_termination = true

    tags = {
      Name = "${local.resource_prefix}-root"
    }
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring = false

  tags = {
    Name = local.resource_prefix
  }

  depends_on = [
    aws_iam_role_policy_attachment.ssm_core
  ]

  lifecycle {
    precondition {
      condition     = length(data.aws_subnets.default.ids) > 0
      error_message = "No default subnet was found in the selected AWS Region."
    }
  }
}

