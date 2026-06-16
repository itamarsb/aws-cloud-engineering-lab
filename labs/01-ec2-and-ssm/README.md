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
