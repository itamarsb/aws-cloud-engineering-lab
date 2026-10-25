# Cloud-Native Track — Docker, Amazon ECR and Amazon ECS

**Status:** proposed learning plan; no new labs are marked complete.

## Purpose and boundaries

This repository owns the **container delivery lifecycle**: build, run, secure, publish, deploy and operate containerized applications with Docker, Docker Compose, Amazon ECR, Amazon ECS Fargate and GitHub Actions.

- Foundational AWS, Linux and Terraform administration remains in [Cloud Infrastructure Operations Lab](https://github.com/itamarsb/cloud-infrastructure-operations-lab).
- Kubernetes, Helm, GitOps and Amazon EKS are owned by [AWS Cloud DevOps & SRE Operations Lab](https://github.com/itamarsb/aws-cloud-devops-sre-operations-lab).
- Existing labs, directories, screenshots and their historical numbering are preserved. This track is a **planning map**, not a renumbering.
- Read each lab's own README and evidence before treating any listed activity as implemented.

## Reference workload

Build a compact Python/FastAPI API with `/health`, `/ready`, version endpoint, basic tests and structured JSON logs. Introduce a PostgreSQL service only when studying Compose networking and persistence. Keep credentials out of version control and avoid committing generated state or secrets.

The same **application contract and image** can later run on Kubernetes; **do not copy** entire CI/CD pipelines or infrastructure between repositories.

## Progressive lab map

| Track | Topic | Deliverable and evidence | Existing roadmap alignment |
|---|---|---|---|
| C01 | Docker fundamentals | Container lifecycle, inspect, logs and cleanup | 07 |
| C02 | Image engineering | Multi-stage Dockerfile, pinned base, reproducible build | 07 |
| C03 | Networking | Custom bridge, DNS, connectivity and isolation tests | 08 |
| C04 | Storage | Volume backup and restore, persistence check | 08 |
| C05 | Compose application | API + database + reverse proxy; smoke test | 08–09 |
| C06 | Container security | Non-root, read-only where feasible, vulnerability report | 07–09 |
| C07 | Registry workflow | Tagged images, digest verification, ECR cleanup | 17 |
| C08 | ECS Fargate | Task definition, service, network rules and health check | 18–20 |
| C09 | Terraform and CI/CD | Planned deployment, GitHub Actions checks and AWS OIDC | 23–26 |
| C10 | Operations and recovery | Fault injection, rollback, logs, final cleanup | 19–20, 26 |

These are **track identifiers**, not new filesystem lab numbers. Implement in the current repository's existing lab numbering where appropriate; add independent labs only when a gap truly warrants one.

## Completion standard per lab

- Explicit prerequisites and architecture/diagram.
- Commands and configuration versioned; exact execution scope and expected results.
- Security and cost notes, particularly when touching AWS.
- Tests / negative tests, captured evidence, and short troubleshooting notes.
- Reproducible removal and **independent post-cleanup verification**.
- A checklist only marked complete after real execution.

## Suggested implementation sequence

1. Audit existing files of Labs 07–09 and 17–26; do not overwrite implemented work.
2. Implement a reusable sample application and local container tests.
3. Complete local container track (C01–C06).
4. Publish to ECR, then provision short-lived ECS infrastructure (C07–C08).
5. Add guarded CI/CD, rollback, and cleanup (C09–C10).

## AWS cost and security guardrails

Use short-lived cloud labs and record teardown evidence. ECR storage, Fargate compute, CloudWatch, load balancers, NAT gateways and public IPv4 can cost money. Do not claim Free Tier coverage. Prefer GitHub Actions OIDC and least-privilege IAM roles over stored static AWS access keys. Document credentials, resource tags, budgets, and cleanup before deployment.

## Portfolio result

Demonstrate a traceable artifact from source commit to tested image digest, ECR registry, healthy ECS deployment, controlled change, rollback and verified cleanup.
