# Terraform AWS Infrastructure Setup

## Project Overview
This project demonstrates how to provision a simple AWS infrastructure using **Terraform**. The infrastructure includes:  
1. **VPC** with two subnets:
   - Public Subnet (for EC2 instance)
   - Private Subnet (for RDS instance)
2. **EC2 Instance** in the public subnet, accessible via SSH.
3. **RDS Instance** in the private subnet, not publicly accessible.
4. **Security Groups** to control network traffic between resources.

---

##  Approach

### Infrastructure Design
1. **VPC Creation:**  
   - A custom VPC is created with a specified CIDR block.
   - Two subnets are defined: 
     - Public Subnet for the EC2 instance.
     - Private Subnet for the RDS instance.

2. **EC2 Instance:**  
   - Deployed in the public subnet with an associated security group allowing SSH (`port 22`) access from specific IPs.

3. **RDS Instance:**  
   - Deployed in the private subnet.
   - The security group allows access from the EC2 instance.

4. **Security Groups:**  
   - EC2 Security Group: Allows inbound SSH access.
   - RDS Security Group: Allows inbound connections from the EC2 instance for database communication.

---

## Statefile Conflict Management

### Why Handle Statefile Conflicts?
When multiple engineers attempt to apply changes using `terraform apply` simultaneously, it can lead to **state corruption or unexpected results**. To prevent this, we use a **remote state backend with state locking**.

### Remote State Management & Locking
1. **S3 Bucket (Remote State Storage):**  
   Stores the `terraform.tfstate` file, making it accessible to all team members.

2. **DynamoDB Table (State Locking):**  
   Prevents concurrent modifications to the state file. When one engineer runs `terraform apply`, a lock is created, blocking others until the operation is complete.

---

## Handling Statefile Conflicts

If an engineer attempts to run `terraform apply` while the lock is active, Terraform will return an error like:
```
Error: Error locking state: Error acquiring the state lock
```
This mechanism ensures only one person modifies the state file at a time.

---

## How to Apply the Configuration

1. **Initialize Terraform:**
```bash
terraform init
```
   This downloads the required provider plugins and configures the backend.

2. **Validate the configuration:**
```bash
terraform validate
```
   Checks for syntax errors.

3. **Check the execution plan:**
```bash
terraform plan
```
   Previews the resources to be created.

4. **Apply the changes:**
```bash
terraform apply
```
   Deploys the infrastructure to AWS. Type `yes` to confirm.

---

## Remote State Backend Configuration (backend.tf)
```
terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket"   # Replace with your S3 bucket name
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```
- **`terraform-state-bucket`:** Stores the state file.
- **`terraform-state-lock`:** DynamoDB table for state locking.

---

## Destroying Resources

To delete all resources, run:
```bash
terraform destroy
```
Type `yes` to confirm the destruction.

---

## Best Practices

1. Use **Remote State Management** with S3 and DynamoDB for teamwork.
2. Always run `terraform plan` before `terraform apply`.
3. Use **Workspaces** for managing different environments (e.g., dev, staging, prod).
4. Follow the **Principle of Least Privilege** for IAM policies.

