# Lab 00 — Terraform Workstation Setup and AWS Authentication

Prepare your local development environment to provision AWS infrastructure securely using Terraform.

---

## Overview

Before Terraform can provision infrastructure on AWS, your local workstation must be properly prepared. This laboratory guides you through the installation of the required tools, the configuration of AWS authentication, and the validation of your local environment.

Unlike the other laboratories in this repository, **Lab 00 does not create any AWS resources**. Its purpose is to establish a secure and reliable foundation for all subsequent Terraform laboratories.

By the end of this laboratory, your workstation will be fully configured to communicate securely with AWS using the AWS CLI and the Terraform AWS Provider.

---

## Learning Objectives

After completing this laboratory, you will be able to:

- Install and verify the required software for Terraform development.
- Understand the role of Git, Visual Studio Code, Terraform CLI, and AWS CLI.
- Configure a secure AWS CLI profile.
- Validate your AWS identity before provisioning infrastructure.
- Understand how Terraform authenticates with AWS.
- Apply security best practices when managing AWS credentials.
- Prepare your workstation for all subsequent laboratories in this repository.

---

## Laboratory Architecture

This laboratory focuses on preparing the local development environment. The following diagram illustrates how Terraform authenticates and communicates with AWS during infrastructure provisioning.

```mermaid
flowchart TB

    Developer["Developer"]

    subgraph Local["Local Workstation"]
        direction TB

        VSCode["Visual Studio Code"]
        Terminal["Terminal<br/>(PowerShell or Bash)"]
        Git["Git"]
        Terraform["Terraform CLI"]
        AWSCLI["AWS CLI"]

        subgraph Config["AWS Local Configuration"]
            direction TB
            Profile["AWS Profile"]
            Credentials["Credentials<br/>Region Configuration"]
        end

        Provider["Terraform AWS Provider"]
    end

    subgraph AWS["AWS Cloud"]
        direction TB
        STS["AWS Security Token Service (STS)"]
        Identity["Authenticated IAM Identity"]
        APIs["AWS Service APIs"]
    end

    Developer --> VSCode
    VSCode --> Terminal

    Terminal --> Git
    Terminal --> Terraform
    Terminal --> AWSCLI

    AWSCLI --> Profile
    Profile --> Credentials

    Credentials --> Provider
    Terraform --> Provider

    AWSCLI -->|"aws sts get-caller-identity"| STS
    Provider -->|"HTTPS API Requests"| STS

    STS --> Identity
    Identity --> APIs
```

And **"Future Terraform Labs"**:


```mermaid
flowchart LR

    Developer["Developer"]

    subgraph Local["Local Workstation"]
        Terraform["Terraform CLI"]
        AWSCLI["AWS CLI"]
        Provider["AWS Provider"]
        Profile["AWS Profile"]
    end

    subgraph AWS["AWS Cloud"]
        STS["AWS STS"]
        IAM["Authenticated IAM Identity"]

        subgraph Future["Future Terraform Labs"]
            EC2["EC2"]
            IAMRole["IAM"]
            SSM["Systems Manager"]
            CloudWatch["CloudWatch"]
            VPC["Networking"]
        end
    end

    Developer --> Terraform
    Developer --> AWSCLI

    AWSCLI --> Profile
    Profile --> Provider
    Terraform --> Provider

    AWSCLI -->|"aws sts get-caller-identity"| STS
    Provider --> STS
    STS --> IAM

    Provider -. Future Labs .-> EC2
    Provider -.-> IAMRole
    Provider -.-> SSM
    Provider -.-> CloudWatch
    Provider -.-> VPC
```

---

## Estimated Time

Approximately **30 to 45 minutes**.

The actual duration depends on whether the required software is already installed and whether an AWS account has already been configured.

---

## Estimated AWS Cost

**Estimated cost: USD $0.00**

This laboratory does **not** provision AWS infrastructure and therefore does not generate charges in your AWS account.

---

## Prerequisites

Before starting this laboratory, ensure that you have:

- An active AWS account.
- Permission to create or use an existing IAM user.
- Internet access.
- Administrative privileges on your local computer to install software.
- A GitHub account (recommended for future laboratories).

---

## Required Software

This laboratory requires the following software:

| Software | Purpose |
|----------|---------|
| **Git** | Version control system used to clone repositories, track changes, and collaborate with other developers. |
| **Visual Studio Code** | Source code editor used to create, edit, and manage Terraform projects. |
| **Terraform CLI** | Infrastructure as Code (IaC) tool used to define, provision, and manage AWS infrastructure. |
| **AWS CLI** | Command-line interface used to authenticate with AWS and interact with AWS services. |

> **Note:**
>
> All software installed in this laboratory will be reused throughout the remaining Terraform laboratories in this repository.

---

## Stage 1 — Install the Required Software

Before Terraform can provision infrastructure on AWS, your workstation must contain the required development tools.

In this stage, you will install and validate the software required for the entire Terraform learning path.

The tools should be installed in the following order:

1. Git
2. Visual Studio Code
3. Terraform CLI
4. AWS CLI

---

### Step 1 — Install Git

Git is the distributed version control system used throughout this repository.

It allows you to:

- Clone GitHub repositories.
- Track changes to your code.
- Create branches.
- Collaborate with other developers.
- Synchronize local and remote repositories.

Download Git from the official website:

https://git-scm.com/

After the installation, open a terminal and verify the installation:

```powershell
git --version
```

Expected output:

```text
git version 2.xx.x.windows.x
```

Your installed version may be different.


![LAB00_Terraform](images/Lab00_Terraform_Clipboard_08-02-2026_01.jpg)


---

### Step 2 — Install Visual Studio Code

Visual Studio Code (VS Code) will be used as the primary development environment throughout this repository.

Although Terraform projects can be edited using any text editor, VS Code provides features that improve productivity, including:

- Syntax highlighting
- Automatic formatting
- Integrated terminal
- Git integration
- Terraform extensions
- AWS Toolkit

Download Visual Studio Code from the official website:

https://code.visualstudio.com/

After installation, verify that VS Code opens correctly.


![LAB00_Terraform](images/Lab00_Terraform_Clipboard_08-02-2026_02.jpg)


---

### Step 3 — Install Terraform CLI

Terraform is an Infrastructure as Code (IaC) tool developed by HashiCorp.

Instead of manually creating infrastructure through the AWS Management Console, Terraform allows infrastructure to be described as code.

This approach provides several advantages:

- Repeatability
- Version control
- Automation
- Consistency
- Documentation
- Reduced human error

Download Terraform from the official website:

https://developer.hashicorp.com/terraform/downloads

After installation, verify the installed version:

```powershell
terraform version
```

Expected output:

```text
Terraform v1.x.x
```

The installed version may differ from the version shown above.


![LAB00_Terraform](images/Lab00_Terraform_Clipboard_08-02-2026_03.jpg)


---

### Step 4 — Install AWS CLI

The AWS Command Line Interface (AWS CLI) is the primary tool used to authenticate your local workstation with AWS.

Terraform does not authenticate directly with AWS.

Instead, the AWS Provider uses credentials that are already available on your local workstation, typically configured through the AWS CLI.

Download AWS CLI Version 2 from the official AWS website:

https://aws.amazon.com/cli/

After installation, verify that the AWS CLI is available:

```powershell
aws --version
```

Expected output:

```text
aws-cli/2.xx.x
```

The installed version may differ from the version shown above.


![LAB00_Terraform](images/Lab00_Terraform_Clipboard_08-02-2026_04.jpg)


In case of an error, completely close your command prompt or VS Code.

Open a new PowerShell window and test the command again: `aws --version`.


![LAB00_Terraform](images/Lab00_Terraform_Clipboard_08-02-2026_05.jpg)


---

## Stage 2 — Create a Secure AWS Identity

Before Terraform can provision infrastructure, AWS must know **who** is making the request and **what actions** that identity is allowed to perform.

In AWS, every API request is associated with an authenticated identity and evaluated against a set of permissions. Understanding this authentication model is essential before using Terraform.

In this stage, you will create or configure an AWS identity that Terraform can use safely to provision infrastructure throughout this learning path.


---


### Step 1 — Understand AWS Identities

AWS provides different types of identities, each designed for a specific purpose.

The most common identities are:

| Identity | Purpose |
|----------|---------|
| **Root User** | The original account owner with unrestricted access to all AWS services. |
| **IAM User** | A permanent identity used by people or applications. |
| **IAM Role** | A temporary identity that can be assumed by AWS services, users, or applications. |

Throughout this repository, these identities will be used for different purposes.

Understanding the difference between them is essential before provisioning infrastructure with Terraform.


---


