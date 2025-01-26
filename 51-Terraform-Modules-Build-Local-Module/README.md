# Build a Local Terraform Module

**Description:** Learn how to build local Terraform modules to automate resource creation and management with reusable configurations.

---

## Step-01: Introduction

### Key Points:
- We will build a **Terraform local module** to host a static website on Azure Storage Account.
- Learn how to call a **Local Reusable Module** into a Root Module.
- Understand how variables from the local module become arguments inside the `module` block when called in the Root Module (`c3-static-website.tf`).
- Define output values for the local module in the Root Module (`c4-outputs.tf`).
- **Terraform Command**: Understand the difference between `terraform init` and `terraform get`.

---

## Step-02: Create Module Folder Structure

- Create a `modules` directory and then a sub-directory named `azure-static-website` for your module.
- Copy the required files from the previous section (`50-Terraform-Azure-Static-Website\terraform-manifests`) into the `azure-static-website` module folder.

### Folder Structure:
```
terraform-manifests/
├── modules/
│   └── azure-static-website/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── versions.tf
├── c1-versions.tf
├── c2-variables.tf
├── c3-static-website.tf
└── c4-outputs.tf
```

---

## Step-03: Root Module: `c1-versions.tf`

- In this step, we’ll configure the Terraform versions and provider.
- We will call the local module inside the Root Module by referencing the newly created module.

```hcl
# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }    
  }
}

# Provider Block
provider "azurerm" {
  features {}          
}
```

---

## Step-04: `c2-variables.tf`

- A placeholder file, where variables can be defined.
- Since our focus here is on calling the local module into the Root Module, we will leave this file simple for now.

---

## Step-05: `c3-static-website.tf`

- We will use the variables defined in the local module’s `variables.tf` as arguments inside the module block here.

```hcl
# Call our Custom Terraform Module which we built earlier
module "azure_static_website" {
  source = "./modules/azure-static-website"  # Mandatory

  # Resource Group
  location = "eastus"
  resource_group_name = "myrg1"

  # Storage Account
  storage_account_name = "staticwebsite"
  storage_account_tier = "Standard"
  storage_account_replication_type = "LRS"
  storage_account_kind = "StorageV2"
  static_website_index_document = "index.html"
  static_website_error_404_document = "error.html"
}
```

---

## Step-06: `c4-outputs.tf`

- Reference the output values from the local module here. The output names defined in the local module (`outputs.tf`) will be used as values in this file.

```hcl
# Output variable definitions
output "root_resource_group_id" {
  description = "Resource group ID"
  value       = module.azure_static_website.resource_group_id
}

output "root_resource_group_name" {
  description = "The name of the resource group"
  value       = module.azure_static_website.resource_group_name
}

output "root_resource_group_location" {
  description = "Resource group location"
  value       = module.azure_static_website.resource_group_location
}

output "root_storage_account_id" {
  description = "Storage account ID"
  value       = module.azure_static_website.storage_account_id
}

output "root_storage_account_name" {
  description = "Storage account name"
  value       = module.azure_static_website.storage_account_name
}
```

---

## Step-07: Execute Terraform Commands

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```
   **Observation:**
   - Verify that the `.terraform` directory now contains a `modules` folder in addition to the `providers` folder.
   - Inside `.terraform/modules`, you should see the `azure-static-website` module.

2. **Validate Terraform Configuration:**
   ```bash
   terraform validate
   ```

3. **Format Terraform Code:**
   ```bash
   terraform fmt
   ```

4. **Plan the Changes:**
   ```bash
   terraform plan
   ```

5. **Apply the Terraform Configuration:**
   ```bash
   terraform apply -auto-approve
   ```

6. **Upload Static Content:**
   - Go to **Storage Accounts** -> `staticwebsitexxxxxx` -> **Containers** -> **$web**.
   - Upload the files from the `static-content` folder.

### Verification:
- Verify that the Azure Storage Account is created.
- Ensure the static website setting is enabled.
- Confirm that the static content has been successfully uploaded.
- Access the static website via the **Primary Endpoint** URL.

---

## Step-08: Destroy and Clean-Up

1. **Destroy Resources:**
   ```bash
   terraform destroy -auto-approve
   ```

2. **Delete Terraform Files:**
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   ```

---

## Step-09: Understand `terraform get` Command

- `terraform init` is used to initialize the configuration by downloading providers and modules.
- **`terraform get`**: Used when you add or modify modules and need to download them again after the initial `terraform init`.
- Both `terraform init` and `terraform get` install and update modules, but `terraform init` also initializes backends and installs plugins.

```bash
# Delete modules in the .terraform folder
ls -lrt .terraform/modules
rm -rf .terraform/modules
ls -lrt .terraform/modules

# Terraform Get
terraform get
ls -lrt .terraform/modules
```

---

## Step-10: Major Difference Between Local and Remote Modules

- **Remote Module**: Terraform downloads it into the `.terraform` directory in your configuration's root directory.
- **Local Module**: Terraform directly refers to the source directory, meaning it notices changes automatically. Local modules do not require re-running `terraform init` or `terraform get` unless the module structure changes.

---
