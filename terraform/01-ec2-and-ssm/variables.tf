variable "aws_region" {
  description = "AWS Region where the Terraform-managed copy of Lab 01 will be created."
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Optional local AWS CLI profile. Keep null to use the standard AWS credential chain."
  type        = string
  default     = null
  nullable    = true
}

variable "project_name" {
  description = "Project name used in tags."
  type        = string
  default     = "aws-cloud-engineering-lab"
}

variable "environment" {
  description = "Environment identifier used in tags."
  type        = string
  default     = "lab"
}

variable "instance_type" {
  description = "EC2 instance type used by the laboratory."
  type        = string
  default     = "t2.micro"
}

variable "ubuntu_release" {
  description = "Ubuntu release used in Canonical's public SSM parameter path."
  type        = string
  default     = "26.04"
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 8

  validation {
    condition     = var.root_volume_size >= 8
    error_message = "root_volume_size must be at least 8 GiB."
  }
}

variable "associate_public_ip" {
  description = "Assign a public IPv4 address to reproduce the networking model used in the manual lab."
  type        = bool
  default     = true
}

