# Terraform Labs

This directory contains Infrastructure as Code implementations
corresponding to the manually created AWS laboratories.

Each Terraform laboratory includes:

- infrastructure provisioning;
- validation commands;
- expected outputs;
- cost considerations;
- automated cleanup;
- post-destroy verification.

```markdown
terraform/
├── README.md
├── 01-ec2-and-ssm/
├── 02-ec2-monitoring-with-cloudwatch-agent/
└── ...
```

```markdown
| Lab | Manual Implementation | Terraform Implementation | Status |
|---|---|---|---|
| 01 | [Manual Lab](../labs/01-ec2-and-ssm/) | [Terraform](./01-ec2-and-ssm/) | ✅ |
| 02 | [Manual Lab](../labs/02-ec2-monitoring-with-cloudwatch-agent/) | [Terraform](./02-ec2-monitoring-with-cloudwatch-agent/) | ⏳ |
| 03 | [Manual Lab](../labs/03-iam-roles-and-policies/) | [Terraform](./03-iam-roles-and-policies/) | ⏳ |
```
