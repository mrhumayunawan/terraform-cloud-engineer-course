# Terraform State Import

**Description:** Learn how to use Terraform to import existing infrastructure into its state management, enabling Terraform to manage resources created outside of it.

---

## Step-01: Introduction

### Key Points:
- Terraform's `import` command allows you to bring pre-existing infrastructure under Terraform management.
- Gradually transition resources to Terraform without rebuilding them.
- Useful for adopting Terraform in legacy environments or partially managed setups.

### References:
- [Terraform Import Documentation](https://www.terraform.io/docs/cli/import/index.html)
- [Azure Resource Group Import Guide](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group#import)

---

## Step-02: Create an Azure Resource Group Manually

1. **Login to Azure Management Console.**
2. Navigate to **Resource Groups** -> **Create**.
3. Configure:
   - **Resource Group Name:** `myrg1`
   - **Region:** `East US`
4. Click **Review + create**, then **Create**.

---

## Step-03: Create Basic Terraform Configuration

### Files:
1. **`c1-versions.tf`:** Define Terraform provider and versions.
2. **`c2-resource-group.tf`:** Define a basic configuration for Azure Resource Group.
   ```hcl
   resource "azurerm_resource_group" "myrg" {
   }
   ```

---

## Step-04: Import Azure Resource Group into Terraform

### Steps:
1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **Run Import Command:**
   ```bash
   terraform import azurerm_resource_group.myrg /subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP_NAME>
   ```
   Example:
   ```bash
   terraform import azurerm_resource_group.myrg /subscriptions/82808767-144c-4c66-a320-b30791668b0a/resourceGroups/myrg1
   ```

3. **Observation:**
   - The `terraform.tfstate` file will now include information about the imported resource.
   - Use `terraform state list` to confirm:
     ```bash
     terraform state list
     ```

---

## Step-05: Build Complete Resource Configuration

1. Refer to the `terraform.tfstate` file to retrieve attributes of the imported resource.
2. Update the `c2-resource-group.tf` file:
   ```hcl
   resource "azurerm_resource_group" "myrg" {
     name     = "myrg1"
     location = "eastus"
   }
   ```

3. **Run Terraform Plan:**
   ```bash
   terraform plan
   ```
   **Goal:** Get the message: `No changes. Infrastructure is up-to-date`.

---

## Step-06: Modify the Resource Group Using Terraform

1. **Update Configuration to Add Tags:**
   ```hcl
   resource "azurerm_resource_group" "myrg" {
     name     = "myrg1"
     location = "eastus"
     tags = {
       "Tag1" = "My-tag-1"
     }
   }
   ```

2. **Run Terraform Commands:**
   - **Plan:**
     ```bash
     terraform plan
     ```
   - **Apply:**
     ```bash
     terraform apply -auto-approve
     ```

3. **Observation:**
   - The resource group in Azure will now include the specified tags.

---

## Step-07: Destroy Imported Resource

1. **Destroy the Resource:**
   ```bash
   terraform destroy -auto-approve
   ```

2. **Clean Up Local Files:**
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   ```

---

## Step-08: Roll Back to Demo State

1. **Comment Resource Configurations:**
   - Update `c2-resource-group.tf` to comment out the resource for a clean slate.

---
