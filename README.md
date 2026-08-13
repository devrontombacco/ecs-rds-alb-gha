## 🚧 Status: In Progress

This project is a **work in progress**. The core infrastructure is deployed and verified working; the CI/CD pipeline (GitHub Actions) is the last piece being built out.

## Objective

Provision a 3-tier AWS architecture (ALB → ECS → RDS) entirely with Terraform, and automate the build/deploy pipeline with GitHub Actions using OIDC (no long-lived AWS keys). The goal is a repeatable, secure pattern for deploying a containerized app behind a load balancer with a managed database backend.

## Architecture

![Architecture diagram](architecture_diagram/architecture_diagram.png)
