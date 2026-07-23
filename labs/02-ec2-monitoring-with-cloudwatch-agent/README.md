# Modern EC2 Monitoring with Amazon CloudWatch Agent


## Learning Objectives

By completing this lab, you will learn how to:

- Reuse an existing EC2 instance
- Install the Amazon CloudWatch Agent
- Configure the agent using a JSON configuration file
- Collect Memory metrics
- Collect Disk metrics
- Send custom metrics to Amazon CloudWatch
- Build a CloudWatch Dashboard
- Validate the collected metrics

## AWS Services

```text
| Service             | Purpose                               |
| ------------------- | ------------------------------------- |
| Amazon EC2          | Linux virtual machine                 |
| AWS Systems Manager | Secure shell access (Session Manager) |
| Amazon CloudWatch   | Metrics and Dashboard                 |
| IAM                 | Permissions for CloudWatch Agent      |
```


---

## Architecture

```Mermaid

flowchart TB

    USER["👤 Engineer / Lab User"]

    subgraph AWS["☁️ AWS Cloud"]

        SSM["🛠️ AWS Systems Manager<br/>Session Manager"]

        IAM["🔐 EC2 IAM Role<br/><br/>AmazonSSMManagedInstanceCore<br/>CloudWatchAgentServerPolicy"]

        subgraph EC2["🖥️ Amazon EC2 Instance — Ubuntu Server"]

            OS["Linux Operating System"]

            SYSTEM_METRICS["System Metrics<br/><br/>CPU • Memory • Disk"]

            CONFIG["📄 CloudWatch Agent Configuration<br/>config.json"]

            AGENT["📊 Amazon CloudWatch Agent"]

            OS --> SYSTEM_METRICS
            SYSTEM_METRICS -->|"Collects metrics"| AGENT
            CONFIG -->|"Defines metrics and intervals"| AGENT
        end

        subgraph CW["📈 Amazon CloudWatch"]

            NAMESPACE["Custom Metrics Namespace<br/>CWAgent"]

            METRICS["CloudWatch Metrics<br/><br/>CPU • Memory • Disk"]

            DASHBOARD["CloudWatch Dashboard<br/>Metric visualization"]

            NAMESPACE --> METRICS
            METRICS --> DASHBOARD
        end

        SSM -->|"Secure access<br/>without inbound SSH"| EC2
        IAM -.->|"Provides permissions"| EC2
        AGENT -->|"Publishes custom metrics<br/>through HTTPS"| NAMESPACE
    end

    USER -->|"Starts Session Manager session"| SSM
    USER -->|"Views collected metrics"| DASHBOARD

    classDef user fill:#f8f9fa,stroke:#57606a,stroke-width:1.5px,color:#24292f;
    classDef management fill:#eaf5ff,stroke:#0972d3,stroke-width:1.5px,color:#16191f;
    classDef security fill:#fff4e5,stroke:#ff9900,stroke-width:1.5px,color:#16191f;
    classDef compute fill:#f3e8ff,stroke:#8c4fff,stroke-width:1.5px,color:#16191f;
    classDef config fill:#f6f8fa,stroke:#57606a,stroke-width:1.5px,color:#24292f;
    classDef monitoring fill:#e8f5e9,stroke:#2e7d32,stroke-width:1.5px,color:#16191f;

    class USER user;
    class SSM management;
    class IAM security;
    class OS,SYSTEM_METRICS,AGENT compute;
    class CONFIG config;
    class NAMESPACE,METRICS,DASHBOARD monitoring;

```

---

### Estimated Time

```text
25–30 minutes
```

---

### Estimated Cost
```text
Free Tier Eligible

t2.micro

CloudWatch custom metrics
≈ a few cents during the lab
```

---


## Prerequisites

Before starting this lab, make sure you have completed:

- ✅ Lab 01 – EC2 with Session Manager
- Existing Ubuntu EC2 instance
- IAM Role with:

```text
AmazonSSMManagedInstanceCore
```
and
```text
CloudWatchAgentServerPolicy
```

This instance is the same one created in Lab 01.


### Required IAM Policies

| Policy | Purpose |
|---------|----------|
| AmazonSSMManagedInstanceCore | Allows Session Manager access |
| CloudWatchAgentServerPolicy | Allows CloudWatch Agent to publish metrics and logs |


### Before

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_18.jpg)

Only one policy attached.

❌ CloudWatchAgentServerPolicy is missing.

---

### After

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_19.jpg)

Both policies attached.

✅ Ready to continue.

---

## Step 1 — Start the EC2 Instance

Start the EC2 instance created during Lab 01.

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_01.jpg)

AND:

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_02.jpg)

Expected state:

```text
Running
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_03.jpg)

---

## Step 2 — Connect using Session Manager

```text
EC2

↓

Instance

↓

Connect

↓

Session Manager

↓

Connect
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_04.jpg)



---

## Step 3 — Update Ubuntu

Run:

```text
sudo apt update
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_05.jpg)


---

## Step 4 — Download the CloudWatch Agent

Instead of trying to install via apt, we will use the official AWS package, which is the most reliable method for Ubuntu:

```text
cd /tmp

wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_06.jpg)

Check:

```text
ls -lh amazon-cloudwatch-agent.deb
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_07.jpg)


---

## Step 5 — Install the Agent

Type:

```text
sudo dpkg -i amazon-cloudwatch-agent.deb
```

Expected output:

```text
Setting up amazon-cloudwatch-agent...
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_08.jpg)





---

## Step 6 — Create the Configuration File

Now we will manually create the configuration file:

```text
sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/etc
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_09.jpg)


Open the editor:
```text
sudo nano /opt/aws/amazon-cloudwatch-agent/etc/config.json
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_10.jpg)


Paste the JSON content below:

```JSON
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "metrics": {
    "append_dimensions": {
      "InstanceId": "${aws:InstanceId}"
    },
    "metrics_collected": {
      "mem": {
        "measurement": [
          "mem_used_percent"
        ]
      },
      "disk": {
        "measurement": [
          "used_percent"
        ],
        "resources": [
          "/"
        ]
      }
    }
  }
}
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_11.jpg)


Save:

```text
CTRL + O

ENTER

CTRL + X
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_12.jpg)



---

## Step 7 — Start the Agent

Type:

```text
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a fetch-config \
-m ec2 \
-c file:/opt/aws/amazon-cloudwatch-agent/etc/config.json \
-s
```


![Lab02](screenshots/Lab02_Clipboard_07-21-2026_14.jpg)




---

## Step 8 — Verify Agent Status

Type:

```text
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a status
```

Expected:

```text
{
  "status":"running"
}
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_15.jpg)



---

## Step 9 — Verify Metrics

Open:

```text
CloudWatch

↓

Metrics

↓

Classic metrics

↓

CWAgent
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_21.jpg)

Verify:

```text
mem_used_percent

disk_used_percent
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_22.jpg)

AND:

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_23.jpg)


---


## Step 10 — Create Dashboard

Open:

```text
CloudWatch

↓

Dashboards

↓

Create Dashboard
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_24.jpg)


Suggested name:

```text
EC2_Monitoring_Dashboard
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_25.jpg)


On the current screen:

- Data source: CloudWatch (already selected)
- Data type: Metrics (already selected)
- Widget type: Line (already selected)

Now click:

```text
Next
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_26.jpg)

Click on:

```text
EC2
```

Choose the category:

```text
Per-Instance Metrics
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_27.jpg)


### Widget 1 — CPU Utilization %

In the list of metrics, look for:

```text
CPUUtilization
```

Check the box next to your instance (`lab01-ec2-ssm`).

You will see the graph appear immediately at the top.

Then click on:

```text
Create widget
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_28.jpg)


### Widget 2 — Memory Used %

After creating the first widget:

1. Click the + button on the Dashboard again.

2. Choose Metrics.

3. Click on CWAgent.

Now the screen should show two categories (the "2" that appears next to CWAgent).

Click on the second one.

Search for:

```text
mem_used_percent
```

Click on:

```text
Create widget
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_29.jpg)


### Widget 3 — Disk Used %

Repeat the process:

```text
+
↓
Metrics
↓
CWAgent
```

Click on the other category.

Search for:

```text
disk_used_percent
```

Select the metric for the main disk (`/`).

Click on:

```text
Create widget
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_30.jpg)


### Final result:

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_31.jpg)


---



> [!TIP]
> **Lesson Learned**
>
> During the development of this lab the CloudWatch Agent installed successfully, but no metrics appeared in CloudWatch.
>
> The root cause was a missing IAM policy:
>
> - CloudWatchAgentServerPolicy
>
> After attaching the policy to the EC2 IAM Role, the agent immediately started publishing metrics.




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
