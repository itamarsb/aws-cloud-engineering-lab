# Terraform Labs

**Language:** **English (default)** | [Português (Brasil)](README.pt-BR.md)

This directory contains Terraform implementations related to the manual AWS laboratories available in this repository.

The Terraform track aims to reproduce the manual lab architectures using **Infrastructure as Code (IaC)**, allowing readers to compare manual provisioning with automated provisioning while following equivalent learning objectives.

## Available laboratories

| Laboratory | Documentation | Status |
| --- | --- | --- |
| **Lab 00 — Workstation setup and AWS authentication** | [English guide](00-workstation-and-aws-authentication/README.md) | Local environment preparation; creates no AWS resources |
| **Lab 01 — EC2 and SSM with Terraform** | [English guide](01-ec2-and-ssm/README.md) | Terraform files available; detailed tutorial still in progress |

> [!NOTE]
> Lab 00 prepares the local environment. For Lab 01, the roadmap covers project setup, infrastructure provisioning, validation, and destruction, but the detailed tutorial currently documents only **Stage 1**, which addresses the project structure and initial configuration. The presence of `.tf` files does not establish that AWS infrastructure has been deployed and validated.

## Intended laboratory contents

As Terraform laboratories are implemented and validated, their documentation is intended to include:

- infrastructure provisioning;
- validation commands;
- expected outputs;
- architecture diagrams;
- cost considerations;
- automated resource cleanup;
- post-destroy verification;
- lessons learned.

## Related manual laboratory

Reference manual implementation:

[Lab 01 — EC2 and SSM](../labs/01-ec2-and-ssm/README.md)

The Terraform implementation aims to reproduce the same architecture through Infrastructure as Code, using distinct resource names to support comparison without replacing the existing manual infrastructure.
