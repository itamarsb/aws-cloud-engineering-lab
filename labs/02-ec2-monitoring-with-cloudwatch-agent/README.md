# Lab 02 - EC2 Monitoring with CloudWatch Agent


## Objective

### In this lab, you will learn how to:

- Install the Amazon CloudWatch Agent
- Collect CPU metrics
- Collect memory metrics
- Collect disk metrics
- Publish custom metrics to CloudWatch
- Create a dashboard to monitor the instance
- What you will learn

### By the end of this lab, you will be able to:

- Monitor a Linux instance using CloudWatch
- Collect metrics that are not available by default (Memory and Disk)
- Create dashboards for observability
- Understand how these metrics are used by DevOps and SRE teams


---

## Architecture

```mermaid
flowchart TB

    EC2["🖥️ Amazon EC2<br/>Ubuntu Server"]

    Agent["📊 CloudWatch Agent"]

    subgraph CloudWatch["Amazon CloudWatch"]
        CPU["CPU Metrics"]
        Memory["Memory Metrics"]
        Disk["Disk Metrics"]
        Dashboard["CloudWatch Dashboard"]
        Alarms["CloudWatch Alarms<br/>(Future Labs)"]
    end

    EC2 --> Agent

    Agent --> CPU
    Agent --> Memory
    Agent --> Disk
    Agent --> Dashboard
    Agent -. Future Labs .-> Alarms
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
