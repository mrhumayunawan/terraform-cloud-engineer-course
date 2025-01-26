# Terraform Cloud with Azure Usecase Demo

## Azure Demo on Terraform Cloud

### Overview:
In this demonstration, we will create several Azure resources using Terraform Cloud. The resources to be created include:

1. **Azure Resource Group**
2. **Azure Virtual Network**
3. **Azure Subnet**
4. **Azure Public IP**
5. **Azure Network Interface**
6. **Azure Linux Virtual Machine**

---

## Step-01: Introduction

### Key Points:
- We will integrate **Terraform Cloud** with **Azure** to manage and provision these resources.
- We will use **Terraform Cloud Workspaces** to handle the execution of plans and state management.
- Learn how to securely authenticate **Terraform Cloud** with **Azure** using a **Service Principal**.

---

## Step-02: Create New GitHub Repository

1. **URL:** [github.com](https://github.com)
2. Click on **Create a new repository**.
3. Fill out the repository details:
   - **Repository Name:** `terraform-cloud-azure-demo1`
   - **Description:** `Terraform Cloud Azure Demo1`
   - **Repo Type:** Public / Private
   - **Initialize this repository with:**
     - **CHECK**: Add a README file
     - **CHECK**: Add `.gitignore`
     - **Select `.gitignore Template`:** Terraform
     - **CHECK**: Choose a license (optional)
     - **Select License:** Apache 2.0 License
4. Click on **Create repository**.

---

## Step-03: Review `.gitignore` Created for Terraform

- Review the `.gitignore` file to ensure that Terraform-specific files such as `.terraform/`, `terraform.tfstate`, and `*.tfvars` are excluded from source control.

---

## Step-04: Clone GitHub Repository to Local Desktop

```bash
# Clone GitHub Repo
git clone https://github.com/<YOUR_GITHUB_ID>/<YOUR_REPO>.git
git clone https://github.com/stacksimplify/terraform-cloud-azure-demo1.git
```

---

## Step-05: Copy Files from `terraform-manifests` to Local Repo & Check-In Code

### List of Files to Copy:
1. `c1-versions.tf`
2. `c2-variables.tf`
3. `c3-locals.tf`
4. `c4-resource-group.tf`
5. `c5-virtual-network.tf`
6. `c6-linux-virtual-machine.tf`
7. `c7-outputs.tf`
8. `dev.auto.tfvars`
9. `ssh-keys` folder
10. `app-scripts` folder

### Verify Locally Before Committing to GitHub:

```bash
# Terraform Init
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Clean-Up files
rm -rf .terraform
```

### Check-In Code to Remote Repository:

```bash
# GIT Status
git status

# Git Local Commit
git add .
git commit -am "TF Files First Commit"

# Push to Remote Repository
git push

# Verify the same on Remote Repository
https://github.com/stacksimplify/terraform-cloud-azure-demo1.git
```

---

## Step-06: Sign-Up for Terraform Cloud - Free Account & Login

1. **Sign-Up URL:** [Terraform Cloud SignUp](https://app.terraform.io/signup/account)
2. **Login URL:** [Terraform Cloud Login](https://app.terraform.io)

---

## Step-07: Create Organization and Enable Free Trial

### Step-07-01: Create Organization
1. **Organization Name:** `hcta-azure-demo1`
2. **Email Address:** `stacksimplify@gmail.com`
3. Click on **Create Organization**.

### Step-07-02: Enable Free Trial for This Organization
1. Go to **Organization Settings** -> `hcta-azure-demo1` -> **Plan & Billing**.
2. Click on **Start your free trial** for Terraform Cloud's paid features.
3. Select **Trial Plan** and click **Start your Free Trial**.

---

## Step-08: Create New Workspace

1. Go to your newly created Organization and click **New Workspace**.
2. **Choose your workflow:** 
   - Version Control Workflow
3. **Connect to VCS:**
   - **Connect to a version control provider:** `github.com`
   - **Authorize Terraform Cloud** by clicking the **Authorize Terraform Cloud** button.
4. **Choose a Repository:**
   - Select `stacksimplify/terraform-cloud-azure-demo1`.
5. **Configure Settings:**
   - **Workspace Name:** `terraform-cloud-azure-demo1` (leave as default)
   - **Workspace Description:** `Terraform Cloud Azure Demo1`
   - **Advanced Settings:**
     - **Terraform Working Directory:** `terraform-manifests`
     - Leave the rest to defaults.
6. Click **Create Workspace**.
7. You should see the message **`Configuration uploaded successfully`**.

---

## Step-09: Terraform Cloud to Authenticate to Azure Using Service Principal with Client Secret

1. **Login to Azure CLI:**
   ```bash
   az login
   ```

2. **Set the Subscription ID:**
   ```bash
   az account set --subscription="SUBSCRIPTION_ID"
   ```

3. **Create Service Principal & Client Secret:**
   ```bash
   az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"
   ```

   Example output:

   ```json
   {
     "appId": "99a2bb50-e5a1-4d72-acd3-e4697ecb5308",
     "password": "0ed3ZeK0DijKvhat~a5NnaQ_bpG_uv_-Xh",
     "tenant": "c81f465b-99f9-42d3-a169-8082d61c677a"
   }
   ```

4. **Authenticate with the Service Principal:**
   ```bash
   az login --service-principal -u CLIENT_ID -p CLIENT_SECRET --tenant TENANT_ID
   ```

5. **Verify Subscription:**
   ```bash
   az account list-locations -o table
   ```

---

## Step-10: Configure Environment Variables in Terraform Cloud

1. Go to **Organization Settings** -> `hcta-azure-demo1` -> **Workspace** -> `hcta-azure-demo1` -> **Variables**.
2. Add the following environment variables:

```bash
ARM_CLIENT_ID="CLIENT_ID"
ARM_CLIENT_SECRET="CLIENT_SECRET"
ARM_SUBSCRIPTION_ID="SUBSCRIPTION_ID"
ARM_TENANT_ID="TENANT_ID"
```

---

## Step-11: Click on Queue Plan

1. Go to **Workspace** -> **Runs** -> **Queue Plan**.
2. Review the generated plan in **Full Screen**.
3. Click on **Confirm & Apply**.
4. Add the comment: **First Run Approved**.

---

## Step-12: Review Terraform State

1. Go to **Workspace** -> **States**.
2. Review the state file.

---

## Step-13: Make Changes in Local Git Repo - Add New Tags

1. Go to `c3-locals.tf` and uncomment the tag `Tag1 = "Terraform-Cloud-Demo1"`.
2. **Check Git Status:**
   ```bash
   git status
   ```

3. **Commit and Push Changes:**
   ```bash
   git add .
   git commit -am "Tag Added"
   git push
   ```

4. **Verify Terraform Cloud:**
   - Go to **Workspace** -> **Runs** to review the plan and apply logs.
   - Add the comment: **Approved new tag changes**.
   - Verify if the new tags are created in Azure Portal.

---

## Step-14: Make Changes in Local Git Repo - When Workspace is Locked

1. Go to `c3-locals.tf` and uncomment the tag `Tag2 = "Terraform-Cloud-Demo1-Workspace-Locked"`.
2. **Check Git Status:**
   ```bash
   git status
   ```

3. **Commit and Push Changes:**
   ```bash
   git add .
   git commit -am "Tag Added - Workspace Locked"
   git push
   ```

4. **Verify Terraform Cloud:**
   - Go to **Workspace** -> **Runs**.
   - You will see a message: **Workspace locked by user**. Unlock it to continue.

---

## Step-15: Review Workspace Settings

1. Go to **Workspace Settings**:
   - General Settings
   - Locking
   - Notifications
   - Run Triggers
   - SSH Key
   - Version Control

---

## Step-16: Destruction and Deletion

1. Go to **Workspace Settings** -> **Destruction and Deletion**.
2. Click **Queue Destroy Plan** to delete the resources from Azure.
3. Go to **Workspace** -> **Runs** -> **Confirm & Apply**.
4. Add the comment: **Approved for Deletion**.

---

## Step-17: Comment `c3-locals.tf`

1. Comment out the tags in `c3-locals.tf` for a seamless demo:

```hcl
common_tags = {
  Service = local.service_name
  Owner   = local.owner
  # Tag1 = "Terraform-Cloud-Demo1"
  # Tag2 = "Terraform-Cloud-Demo1-Workspace-Locked"
}
```

---
