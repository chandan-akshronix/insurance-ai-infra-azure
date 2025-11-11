# 🏗️ Insurance AI Infrastructure (Azure Dev Environment)

This repository contains the **Terraform Infrastructure** and **automation scripts** for the AI-based Insurance project — built and deployed on **Microsoft Azure Cloud**.

---

## 🚀 Overview
The infra provisions all essential Dev components required for Jenkins CI/CD, SonarQube code analysis, Nexus artifact management, and containerized microservices deployment (initially via Docker, later to AKS).

---

## 🧩 Components
| Component | Purpose | Deployment |
|------------|----------|-------------|
| **Jenkins** | CI/CD automation server | Azure VM |
| **SonarQube** | Code quality & static analysis | Docker container |
| **Nexus** | Artifact repository | Docker container |
| **Docker / AKS** | Container & Kubernetes orchestration | Dev → Staging |

---

## ⚙️ Prerequisites

Before deploying, ensure the following tools are installed and configured on your local system:

- **Azure CLI** → Used for authentication and managing Azure resources  
- **Terraform (≥ v1.5)** → For Infrastructure as Code deployment  
- **SSH Keypair** → For VM authentication and secure access  

---

### 🧩 Azure Setup Steps

1. **Login to Azure Cloud**
   ```bash
   az login
Connects your local system to your Azure account.

2. **Set Azure subscription ID**
   ```bash
   az account set --subscription "<subscription-id>"
After login, select your desired Azure subscription ID for resource deployment.

3. **Generate SSH Key**
   ```bash
    ssh-keygen -t rsa -b 4096
Creates a secure SSH keypair (public & private key) for VM access.


### 🧱 Terraform Commands

1. **Initialize Terraform**
   ```bash
   terraform init
Initializes backend and downloads required Azure provider plugins.

2. **Create Workspaces**
   ```bash
   terraform workspace new "dev"
Creates separate environments for Dev and Stage to isolate deployments.

3. **Select Workspace**
   ```bash
    terraform workspace select "env-name"
Switches to the desired environment (e.g., dev, stage).

4. **Show Current Workspace**
   ```bash
   terraform workspace show
Displays the currently active workspace.

5. **Validate Configuration**
   ```bash
   terraform validate
Checks for syntax and configuration correctness in .tf files.

6. **Preview Infrastructure Plan**
   ```bash
    terraform plan
Displays an execution plan of what Terraform will create or modify.

7. **Apply Infrastructure**
   ```bash
   terraform apply -auto-approve
Provisions all defined resources automatically in Azure.

8. **Destroy Infrastructure**
   ```bash
    terraform destroy -auto-approve
Destroy all the resources that has been created with the help of terraform.






























