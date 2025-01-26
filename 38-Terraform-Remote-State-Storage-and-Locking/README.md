# Terraform Remote State Storage & Locking

**Description:** Learn how to configure Terraform to use remote state storage with Azure Storage Account, enabling state locking and versioning for collaborative environments.

---

## Step-01: Introduction

### Overview:
- Understand Terraform backends and their role in managing remote state storage.
- Default state file: `terraform.tfstate` (local).
- Remote state storage advantages:
  - Team collaboration.
  - State locking to prevent conflicts.
  - Versioning for state file history.

### Objective:
- Configure Azure Storage Account as the backend for Terraform state file storage.

---

## Step-02: Create Azure Storage Account

### Step 2.1: Create a Resource Group
1. Navigate to **Resource Groups** -> **Add**.
2. Set the following values:
   - **Resource Group Name:** `terraform-storage-rg`
   - **Region:** `East US`
3. Click **Review + Create**, then **Create**.

### Step 2.2: Create a Storage Account
1. Navigate to **Storage Accounts** -> **Add**.
2. Set the following values:
   - **Resource Group:** `terraform-storage-rg`
   - **Storage Account Name:** `terraformstate201` (*unique across Azure*).
   - **Region:** `East US`
   - **Performance:** Standard
   - **Redundancy:** Geo-Redundant Storage (GRS)
3. Under **Data Protection**, enable **Blob versioning**.
4. Click **Review + Create**, then **Create**.

### Step 2.3: Create a Container
1. Go to **Storage Account** -> `terraformstate201` -> **Containers** -> **+Container**.
2. Set the following values:
   - **Name:** `tfstatefiles`
   - **Public Access Level:** Private (no anonymous access)
3. Click **Create**.

---

## Step-03: Configure Terraform Backend

### Add Backend Configuration:
Update the `c1-versions.tf` file to include the backend block:
```hcl
terraform {
  backend "azurerm" {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstate201"
    container_name        = "tfstatefiles"
    key                   = "terraform.tfstate"
  }
}
```

### Reference:
- [Terraform Backend with Azure Storage Account](https://www.terraform.io/docs/language/settings/backends/azurerm.html)

---

## Step-04: Review Terraform Files

Ensure the following files are configured:
1. `c1-versions.tf`
2. `c2-variables.tf`
3. `c3-locals.tf`
4. `c4-resource-group.tf`
5. `c5-virtual-network.tf`
6. `c6-linux-virtual-machine.tf`
7. `c7-outputs.tf`
8. `terraform.tfvars`

---

## Step-05: Test with Remote State Storage Backend

### Steps:
1. **Initialize Terraform:**
   ```bash
   terraform init
   ```
   **Observation:**
   - Backend initialization message.
   - Verify the `terraform.tfstate` file is created in Azure Storage Account.

2. **Validate Configuration:**
   ```bash
   terraform validate
   ```

3. **Plan Resources:**
   ```bash
   terraform plan
   ```
   **Observation:**
   - Terraform acquires a state lock during planning.

4. **Apply Resources:**
   ```bash
   terraform apply -auto-approve
   ```

5. **Verify State File:**
   - Check the Azure Storage Account to confirm the `terraform.tfstate` file exists.

6. **Access Application:**
   ```bash
   http://<Public-IP>
   ```

---

## Step-06: Test State File Versioning

1. **Update Configuration:**
   Uncomment the following in `c3-locals.tf`:
   ```hcl
   common_tags = {
     Service = local.service_name
     Owner   = local.owner
     Tag     = "demo-tag1"  # Uncomment during this step
   }
   ```

2. **Run Terraform Commands:**
   ```bash
   terraform plan
   terraform apply -auto-approve
   ```

3. **Verify State File:**
   **Observations:**
   - A new version of the `terraform.tfstate` file is created.
   - During execution, the state file will be in "leased" status (locked).
   - Once the process is complete, the status returns to "available."

---

## Step-07: Destroy Resources

### Steps:
1. **Destroy Resources:**
   ```bash
   terraform destroy -auto-approve
   ```

2. **Clean Files:**
   ```bash
   rm -rf .terraform*
   ```

3. **Reset Configuration:**
   Comment out the `Tag` key in `c3-locals.tf` for seamless future demos:
   ```hcl
   common_tags = {
     Service = local.service_name
     Owner   = local.owner
     # Tag = "demo-tag1"
   }
   ```

---

## References

1. [Terraform Backends](https://www.terraform.io/docs/language/settings/backends/index.html)
2. [Terraform State Storage](https://www.terraform.io/docs/language/state/backends.html)
3. [Terraform State Locking](https://www.terraform.io/docs/language/state/locking.html)
4. [Remote Backends - Enhanced](https://www.terraform.io/docs/language/settings/backends/remote.html)

---
