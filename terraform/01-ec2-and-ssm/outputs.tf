output "aws_account_id" {
  description = "AWS account where the Terraform resources were created."
  value       = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  description = "AWS Region selected for the laboratory."
  value       = var.aws_region
}

output "instance_id" {
  description = "Terraform-managed EC2 instance ID."
  value       = aws_instance.lab01.id
}

output "instance_name" {
  description = "Terraform-managed EC2 instance Name tag."
  value       = aws_instance.lab01.tags["Name"]
}

output "instance_state" {
  description = "EC2 instance state known by Terraform."
  value       = aws_instance.lab01.instance_state
}

output "private_ip" {
  description = "Private IPv4 address of the EC2 instance."
  value       = aws_instance.lab01.private_ip
}

output "public_ip" {
  description = "Public IPv4 address when public addressing is enabled."
  value       = aws_instance.lab01.public_ip
}

output "iam_role_name" {
  description = "IAM role attached to the EC2 instance."
  value       = aws_iam_role.ec2_ssm.name
}

output "instance_profile_name" {
  description = "IAM instance profile attached to the EC2 instance."
  value       = aws_iam_instance_profile.ec2_ssm.name
}

output "security_group_id" {
  description = "Security group ID. The group has no inbound rules."
  value       = aws_security_group.ec2_ssm.id
}

output "ubuntu_ami_id" {
  description = "Ubuntu AMI ID resolved dynamically from Canonical's public SSM parameter."
  value       = data.aws_ssm_parameter.ubuntu_ami.value
}

output "session_manager_command" {
  description = "AWS CLI command for opening a Session Manager shell."
  value       = "aws ssm start-session --target ${aws_instance.lab01.id} --region ${var.aws_region}"
}

