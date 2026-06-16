# Lab 01 - EC2 Instance with SSM Access

## Overview

This lab demonstrates how to deploy an Amazon EC2 instance and securely access it using AWS Systems Manager Session Manager without SSH keys or inbound SSH ports.

The objective is to follow modern AWS security best practices while gaining hands-on experience with EC2, IAM, and Systems Manager.

---

## Architecture


```text
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

### Objective

Create an IAM Role that allows the EC2 instance to communicate securely with AWS Systems Manager (SSM).

This role will later be attached to the EC2 instance, enabling Session Manager access without using SSH keys or opening inbound ports.

---

### Why this step is necessary

AWS Systems Manager requires permissions to:

- Register the instance as a managed node
- Establish Session Manager connections
- Retrieve configuration data
- Communicate securely with AWS Systems Manager services

Without an IAM Role, the EC2 instance cannot authenticate to AWS APIs.

This approach follows AWS security best practices by using temporary credentials instead of static access keys.

---

### Step 1.1 – Open IAM Console

Navigate to:

![IAM](screenshots/Clipboard_06-14-2026_0101.jpg)

IAM → Roles

![Roles](screenshots/Clipboard_06-14-2026_0202.jpg)

Click **Create role**.

![Create](screenshots/Clipboard_06-14-2026_03.jpg)

---

### Step 1.2 – Select Trusted Entity

Choose:

- Trusted entity type: AWS service

- Service: EC2

- Use case: EC2

![Trusted](screenshots/Clipboard_06-14-2026_04.jpg)


Click Next.

---

### Why EC2 Must Be Selected

This configuration establishes a trust relationship between AWS EC2 and IAM.

It allows EC2 instances to assume this role and receive temporary credentials automatically.

No usernames, passwords, or access keys are required.

---

Search for:

```bash
AmazonSSMManagedInstanceCore
```

![Search](screenshots/Clipboard_06-14-2026_06.jpg)

Select the policy.

Click Next.

AmazonSSMManagedInstanceCore grants the minimum permissions required for:

- Session Manager
- Systems Manager Inventory
- Patch Manager
- Run Command
- Managed Instance registration

This follows the Principle of Least Privilege.

Role Name:

```bash
EC2-SSM-Role
```

Description:

```bash
Allows EC2 instances to communicate with AWS Systems Manager.
```

---
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
