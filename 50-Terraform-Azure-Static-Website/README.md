# Build a Static Website on Azure with Terraform

**Description:** Learn how to automate the creation and hosting of a Static Website on Azure using Terraform, including the creation of a reusable module for this process.

---

## Step-00: Introduction

### Key Points:
- **End Goal:** Create a reusable Terraform Local Module.
  - Create a Terraform module.
  - Use local Terraform modules in your configuration.
  - Configure modules with variables.
  - Use module outputs.
- **Usecase:** Hosting a static website using Azure Storage Account.
  1. Create an Azure Storage Account.
  2. Enable the `Static Website` option.
  3. Upload Static Content and test.
  4. Automate steps 1 and 2 using a re-usable Terraform module.

### Sections Overview:
- **Section 1 - Full Manual:** Host a Static Website on Azure using the Azure Portal.
- **Section 2 - Terraform Resources:** Automate the process from Section 1 using Terraform resources.
- **Section 3 - Terraform Modules:** Create a reusable Terraform module for hosting a static website.

---

## Module-1: Manual - Hosting a Static Website with Azure Storage Account

### Step-01: Create Azure Storage Account

1. **Login to Azure Portal:**
   - Navigate to **Storage Accounts** -> **Create**.
   - **Resource Group:** `myrg-sw-1`
   - **Storage Account Name:** `staticwebsitek123` (Unique name across Azure).
   - **Region:** East US
   - **Performance:** Standard
   - **Redundancy:** LRS (Locally redundant storage).
   - Click **Review + Create** and then **Create**.

---

### Step-02: Enable Static Website

1. Go to **Storage Account** -> `staticwebsitek123` -> **Data Management** -> **Static Website**.
2. Enable the static website feature:
   - **Index Document Name:** `index.html`
   - **Error Document Path:** `error.html`

---

### Step-03: Upload Static Content

1. Navigate to **Storage Account** -> `staticwebsitek123` -> **Data Storage** -> **Containers** -> **$web**.
2. Upload the static files from the `static-content` folder:
   - `index.html`
   - `error.html`

---

### Step-05: Access Static Website

1. Go to **Storage Account** -> `staticwebsitek123` -> **Data Management** -> **Static Website**.
2. Copy the **Primary Endpoint** URL:
   ```plaintext
   https://staticwebsitek123.z13.web.core.windows.net/
   ```

---

### Step-06: Conclusion

- We've manually hosted a static website on Azure Storage Account using the Azure Portal.  
- Next, we will automate this process using Terraform.

---

## Module-2: Create Terraform Configuration to Host a Static Website on Azure

### File Structure:
1. `versions.tf`
2. `main.tf`
3. `variables.tf`
4. `outputs.tf`
5. `terraform.tfvars`

---

### Step-01: `versions.tf`

```hcl
# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }  
    random = {
      source = "hashicorp/random"
      version = ">= 3.0"
    }  
    null = {
      source = "hashicorp/null"
      version = ">= 3.0"
    }             
  }
}
```

---

### Step-02: `variables.tf`

```hcl
# Input variable definitions
variable "location" {
  description = "The Azure Region in which all resources groups should be created."
  type = string 
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type = string     
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type = string   
}

variable "storage_account_tier" {
  description = "Storage Account Tier"
  type = string   
}

variable "storage_account_replication_type" {
  description = "Storage Account Replication Type"
  type = string   
}

variable "storage_account_kind" {
  description = "Storage Account Kind"
  type = string   
}

variable "static_website_index_document" {
  description = "Static website index document"
  type = string   
}

variable "static_website_error_404_document" {
  description = "Static website error 404 document"
  type = string   
}

variable "static_website_source_folder" {
  description = "Static website source folder"
  type = string  
}
```

---

### Step-03: `main.tf`

```hcl
# Provider Block
provider "azurerm" {
  features {}          
}

# Random String Resource
resource "random_string" "myrandom" {
  length = 6
  upper = false 
  special = false
  number = false   
}

# Create Resource Group
resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
}

# Create Azure Storage account
resource "azurerm_storage_account" "storage_account" {
  name                = "${var.storage_account_name}${random_string.myrandom.id}"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  account_tier         = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  account_kind         = var.storage_account_kind

  static_website {
    index_document    = var.static_website_index_document
    error_404_document = var.static_website_error_404_document  
  }
}
```

---

### Step-04: `terraform.tfvars`

```hcl
location = "eastus"
resource_group_name = "myrg1"
storage_account_name = "staticwebsite"
storage_account_tier = "Standard"
storage_account_replication_type = "LRS"
storage_account_kind = "StorageV2"
static_website_index_document = "index.html"
static_website_error_404_document = "error.html"
static_website_source_folder = "../static-content"
```

---

### Step-05: `outputs.tf`

```hcl
# Output variable definitions
output "resource_group_id" {
  description = "Resource group ID"
  value       = azurerm_resource_group.resource_group.id 
}

output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.resource_group.name
}

output "resource_group_location" {
  description = "Resource group location"
  value       = azurerm_resource_group.resource_group.location
}

output "storage_account_id" {
  description = "Storage account ID"
  value       = azurerm_storage_account.storage_account.id
}

output "storage_account_name" {
  description = "Storage account name"
  value       = azurerm_storage_account.storage_account.name 
}
```

---

### Step-06: Execute Terraform Commands

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **Validate Configuration:**
   ```bash
   terraform validate
   ```

3. **Format Configuration:**
   ```bash
   terraform fmt
   ```

4. **Plan:**
   ```bash
   terraform plan
   ```

5. **Apply Configuration:**
   ```bash
   terraform apply -auto-approve
   ```

### Verification:
- Go to **Storage Account** -> `staticwebsitek123` -> **Containers** -> **$web** to verify that static content has been uploaded.
- Access the static website via the **Primary Endpoint** URL.

---

### Step-07: Destroy and Clean-Up

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

## Step-08: Conclusion

By using the provided Terraform configurations, we’ve successfully hosted a static website on Azure Storage Account. In the next step, we will convert these Terraform configurations into a reusable module.

---

