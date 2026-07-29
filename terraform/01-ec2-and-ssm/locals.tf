locals {
  resource_prefix = "lab01-ec2-ssm-tf"

  ubuntu_ami_parameter = "/aws/service/canonical/ubuntu/server/${var.ubuntu_release}/stable/current/amd64/hvm/ebs-gp3/ami-id"

  common_tags = {
    Project        = var.project_name
    Environment    = var.environment
    Lab            = "01-ec2-and-ssm"
    ManagedBy      = "Terraform"
    Provisioning   = "Infrastructure-as-Code"
    Implementation = "Parallel-Terraform"
    Repository     = "github.com/itamarsb/aws-cloud-engineering-lab"
  }
}

