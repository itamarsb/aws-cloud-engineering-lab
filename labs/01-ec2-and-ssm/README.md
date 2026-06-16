# Lab 01 - EC2 Instance with SSM Access

## Overview

This lab demonstrates how to deploy an Amazon EC2 instance and securely access it using AWS Systems Manager Session Manager without SSH keys or inbound SSH ports.

The objective is to follow modern AWS security best practices while gaining hands-on experience with EC2, IAM, and Systems Manager.

---

## Architecture

## Architecture

```text
<p style="text-align:center;">
┌─────────────────────┐
│   Administrator     │
│  (AWS Console User) │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ AWS Session Manager │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ AWS Systems Manager │
│     (SSM Agent)     │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ Ubuntu EC2 Instance │
│  lab01-ec2-ssm      │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│ IAM Role Attached   │
│  EC2-SSM-Role       │
└─────────────────────┘
</p>
```


---

## Learning Objectives

After completing this lab, you will be able to:

* Create an EC2 instance
* Configure IAM Roles
* Configure AWS Systems Manager
* Register a Managed Node
* Access Linux through Session Manager
* Validate system configuration
* Follow AWS security best practices

---

## Prerequisites

* AWS Account
* IAM User with AdministratorAccess
* AWS Region: us-east-1

---

## Step 1 - Create IAM Role

Why?

IAM Roles provide temporary credentials to EC2 instances without requiring access keys.

[screenshot]

### Configuration

* Trusted entity: AWS Service
* Service: EC2
* Permission: AmazonSSMManagedInstanceCore

[screenshot]

### Validation

Verify the role has been created successfully.

[screenshot]


---


## Production Considerations

For simplicity, resource tagging was intentionally omitted in this lab.

In production environments, tags should be applied to all AWS resources to support:
- Cost allocation
- Governance
- Resource ownership
- Automation
- Compliance

## Why Session Manager Instead of SSH?

This lab intentionally avoids SSH access and follows a modern AWS operational model based on Systems Manager Session Manager.

Benefits include:

- No SSH key management
- No inbound SSH ports
- Reduced attack surface
- Centralized access control through IAM
- Improved auditing and governance

SSH remains an important and widely used administration method, but Session Manager represents a modern alternative commonly adopted in AWS environments.

Session Manager was chosen because it eliminates the need to expose port 22, reduces SSH key management, integrates with IAM, and improves access traceability. However, SSH remains widely used and necessary in various scenarios, especially outside the AWS ecosystem, such as in Azure or GCP environments.
