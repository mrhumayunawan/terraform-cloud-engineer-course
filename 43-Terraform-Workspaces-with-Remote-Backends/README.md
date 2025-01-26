# Terraform Workspaces with Remote Backend

**Description:** Learn how to manage Terraform workspaces using a remote backend (Azure Storage) and understand how Terraform state files are organized in the storage backend.

---

## Step-01: Introduction

### Overview:
- Use **Terraform Remote Backend (Azure Storage)** to manage state files for multiple workspaces.
- Create and manage 4 workspaces:
  - **default**
  - **dev**
  - **staging**
  - **prod**
- Understand how Terraform stores workspace-specific state files in the Azure Storage Account.

---

## Step-02: Update Terraform Configuration (`c1-versions.tf`)

### Add Backend Block:
```hcl
terraform {
  backend "azurerm" {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstate201"
    container_name        = "tfstatefiles"
    key                   = "cliworkspaces-terraform.tfstate"
  }
}
```

---

## Step-03: Create and Manage Workspaces

### Steps:

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```
   **Observation:**
   - Go to Azure Management Console -> `terraform-storage-rg` -> `terraformstate201` -> `tfstatefiles`.
   - Verify the `cliworkspaces-terraform.tfstate` file (default workspace) is created.
   - Check file size (approx. 155 bytes).

2. **List Existing Workspaces:**
   ```bash
   terraform workspace list
   ```

3. **Show Current Workspace:**
   ```bash
   terraform workspace show
   ```

4. **Create New Workspaces:**
   ```bash
   terraform workspace new dev
   terraform workspace new staging
   terraform workspace new prod
   ```

5. **Verify State Files in Storage Account:**
   - Files should be named as follows:
     - `cliworkspaces-terraform.tfstate`
     - `cliworkspaces-terraform.tfstate:dev`
     - `cliworkspaces-terraform.tfstate:staging`
     - `cliworkspaces-terraform.tfstate:prod`

6. **Delete Workspaces:**
   ```bash
   terraform workspace select default
   terraform workspace delete dev
   terraform workspace delete staging
   terraform workspace delete prod
   ```

   **Observation:**
   - Workspace-specific state files will be automatically deleted from Azure Storage when their respective workspaces are deleted.
   - The default workspace state file (`cliworkspaces-terraform.tfstate`) will remain, as the default workspace cannot be deleted.

---

## Step-04: Clean-Up Local Files

### Steps:
1. **Remove Local Terraform Files:**
   ```bash
   rm -rf .terraform*
   ```

---

## References

1. [Terraform Workspaces](https://www.terraform.io/docs/language/state/workspaces.html)
2. [Managing Workspaces](https://www.terraform.io/docs/cli/workspaces/index.html)

---
