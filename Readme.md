# Terraform + Jenkins CI/CD Project

## Overview
This project demonstrates an **end-to-end CI/CD pipeline** using **Terraform and Jenkins** to automate infrastructure provisioning and destruction on AWS.

The pipeline allows you to:
- Automatically **create EC2 instances** with Terraform.
- **Destroy infrastructure** safely after testing or use.
- Maintain **Terraform state remotely** (S3 + DynamoDB).
- Use **Jenkins credentials** for secure SSH key management.

---

## Project Structure
```
.
├── Jenkinsfile            # Pipeline to create and destroy infrastructure using Terraform
├── backend.tf             # Remote backend on s3 and dynamodb table
├── main.tf                # Terraform configuration file
├── variables.tf           # Terraform variables
├── outputs.tf             # Terraform outputs (instance IPs, IDs, etc.)
└── README.md              # Documentation
```

---

## Jenkins Setup

### 1. Create Jenkins Credentials
- Go to **Manage Jenkins → Credentials → Global → Add Credentials**.
- Choose **SSH Username with private key**.
- ID: `terraform-key`
- Username: `ubuntu` (or your EC2 username)
- Paste the **private key** you use for AWS EC2.

### 2. Configure Remote Backend (Recommended)
In your Terraform configuration, add:
```hcl
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "infra/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock"
  }
}
```
This ensures that your **state file is stored remotely**, allowing Jenkins and Terraform to work from anywhere safely.

---

## Jenkins Pipeline Jobs

### 1. Infrastructure Creation Job
- Name: `terraform-create`
- Pipeline Script Path: `Jenkinsfile-create`
- Trigger manually or via Git push.
- This will:
  1. Initialize Terraform.
  2. Validate and plan configuration.
  3. Apply infrastructure changes.

### 2. Infrastructure Destroy Job
- Name: `terraform-destroy`
- Pipeline Script Path: `Jenkinsfile-destroy`
- Trigger manually when you want to destroy resources.
- This will:
  1. Initialize Terraform.
  2. Run `terraform destroy -auto-approve`.
  3. Clean up resources properly.

---

## Environment Variables
| Variable | Description |
|-----------|--------------|
| AWS_ACCESS_KEY_ID | Your AWS access key |
| AWS_SECRET_ACCESS_KEY | Your AWS secret key |
| TF_VAR_region | AWS region |
| TF_VAR_instance_type | EC2 instance type |

Set them in Jenkins under **Build Environment → Inject environment variables** or as **Jenkins credentials**.

---

## Example Workflow

1. Push code to GitHub.
2. Jenkins triggers the **create job**.
3. Terraform provisions EC2 instances and outputs IPs.
4. After testing, manually trigger the **destroy job**.
5. Terraform cleans up all resources.

---

## Notes
- Always test in a **non-production** AWS account.
- Ensure your **IAM user** has permissions for EC2, S3, and DynamoDB.
- Keep your **Terraform backend and credentials secure**.

---

## License
MIT License © 2025