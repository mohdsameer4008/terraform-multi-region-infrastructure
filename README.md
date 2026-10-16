# Multi-Region AWS Infrastructure Automation with Terraform

## Project overview

This project provisions reusable AWS networking infrastructure in two separate regions:
- `us-east-1` (N. Virginia)
- `us-west-2` (Oregon)

Each region contains one VPC, two public subnets, two private subnets, an Internet Gateway, and separate public/private route tables. A reusable Terraform module avoids duplicating resource definitions.

## Architecture

```text
                         Terraform / GitHub
                                |
                      Format -> Validate -> Plan
                                |
                 +--------------+--------------+
                 |                             |
          AWS us-east-1                  AWS us-west-2
          VPC 10.10.0.0/16              VPC 10.20.0.0/16
          |                             |
       Internet Gateway              Internet Gateway
          |                             |
     Public Route Table              Public Route Table
       /          \                    /          \
   Public AZ A  Public AZ B        Public AZ A  Public AZ B
   Private AZ A Private AZ B       Private AZ A Private AZ B
```

The VPCs are independent. This project does not configure cross-region connectivity, NAT gateways, EC2 instances, or security groups.

## Folder structure

```text
terraform-multi-region-infrastructure/
├── main.tf
├── provider.tf
├── terraform.tf
├── variables.tf
├── outputs.tf
├── README.md
├── .gitignore
├── .github/
│   └── workflows/
│       └── terraform.yml
└── modules/
    └── vpc/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Prerequisites

1. An AWS account with permission to create VPCs, subnets, route tables, route table associations, and Internet Gateways in both regions.
2. Terraform CLI version 1.5 or later.
3. AWS CLI configured with credentials, or another supported AWS credential provider.
4. Git.

**Never commit AWS access keys, secret keys, session tokens, or state files to GitHub.** Prefer temporary credentials or an IAM role with least-privilege permissions.

## Deploy

Run these commands from the project root:

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

Review the plan before entering `yes` at the apply confirmation. The deployment creates billable cloud resources even though the VPC networking resources themselves generally do not have an hourly charge; associated services and data transfer may incur charges.

## Verify

```bash
terraform output
terraform state list
```

In the AWS Console, switch between `us-east-1` and `us-west-2` and verify the VPCs, subnets, Internet Gateways, route tables, and route associations.

## Cleanup

When finished, remove resources created by this project:

```bash
terraform destroy
```

Review the destroy plan and confirm only if it targets the resources you created for this project.

## Important networking note

Public subnets have a default route (`0.0.0.0/0`) to the Internet Gateway and automatically assign public IPv4 addresses to launched instances. A subnet is not fully reachable from the internet by itself: instances also need suitable security group rules, a public IPv4 address, and any required network ACL rules.

Private subnets have no default internet route in this project. They are isolated from direct internet routing; add NAT gateways only if private resources need outbound internet access. NAT gateways incur ongoing charges.

## GitHub Actions

The included workflow checks formatting and validates the Terraform configuration on pushes and pull requests. It does not run `apply` and does not need AWS credentials. For a stronger workflow, add a reviewed `terraform plan` job and configure AWS authentication through GitHub OIDC with a tightly scoped IAM role.

## Optional remote state in S3

For a team-ready enhancement, create an S3 bucket in advance with Block Public Access enabled, versioning enabled, and encryption enabled. Then configure an S3 backend in the `terraform` block. Backend settings cannot use ordinary Terraform input variables.

Example backend block (replace the bucket and key with your own unique values):

```hcl
terraform {
  backend "s3" {
    bucket       = "REPLACE-WITH-YOUR-UNIQUE-STATE-BUCKET"
    key          = "multi-region/network/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
```

After adding the backend, run `terraform init` and follow Terraform's prompts carefully if migrating existing local state. Protect access to the state bucket: Terraform state can contain sensitive infrastructure metadata.

## Resume description

**Multi-Region AWS Infrastructure Automation Using Terraform**
- Built reusable Terraform modules to provision AWS VPC networking in two regions.
- Automated public/private subnet creation across two Availability Zones per region, with Internet Gateways and route tables.
- Used Terraform variables and outputs to improve module reusability and infrastructure visibility.
- Added GitHub Actions checks for Terraform formatting and configuration validation.

Only list tasks as completed on your resume after you have deployed, verified, and documented them.
