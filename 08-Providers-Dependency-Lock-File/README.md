# Terraform Provider Dependency Lock File

**Description:** Learn about Terraform's Provider Dependency Lock File, introduced in Terraform v0.14, and its importance in managing consistent provider versions across environments.

---

## Step 1: Introduction
The Provider Dependency Lock File, introduced in Terraform v0.14, ensures consistent provider versions across different environments or systems, reducing issues caused by provider version mismatches.

---

## Step 2: Create or Review `c1-versions.tf`
### Key Concepts:
1. **Provider Versions**:
   - Define specific versions for Terraform, Azure, and Random Pet providers.
2. **Azure RM Provider v1.44.0**:
   - Lacks the `features {}` block required in later versions.
3. **Random Provider**:
   - Used for generating random strings.

#### Example Configuration (`c1-versions.tf`):
```hcl
# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "1.44.0" # Specific version for dependency lock demo
    }
    random = {
      source = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

# Provider Block
provider "azurerm" {
  # features {} # Commented for Dependency Lock File Demo
}
```

For more information, see [Azure Provider v1.44.0 Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/1.44.0/docs).

---

## Step 3: Create or Review `c2-resource-group-storage-container.tf`
### Resources:
1. **Azure Resource Group**: Creates a resource group in East US.
2. **Random String**: Generates a random string.
3. **Azure Storage Account**: Creates a storage account in the resource group.

#### Example Configuration (`c2-resource-group-storage-container.tf`):
```hcl
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg1" {
  name     = "myrg-1"
  location = "East US"
}

# Resource-2: Random String
resource "random_string" "myrandom" {
  length  = 16
  upper   = false
  special = false
}

# Resource-3: Azure Storage Account
resource "azurerm_storage_account" "mysa" {
  name                     = "mysa${random_string.myrandom.id}"
  resource_group_name      = azurerm_resource_group.myrg1.name
  location                 = azurerm_resource_group.myrg1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  account_encryption_source = "Microsoft.Storage"

  tags = {
    environment = "staging"
  }
}
```

---

## Step 4: Initialize and Apply the Configuration
```bash
# Start with Base v1.44 `.terraform.lock.hcl`
cp .terraform.lock.hcl-v1.44 .terraform.lock.hcl

# Initialize Terraform
terraform init

# Compare Lock Files
diff .terraform.lock.hcl-v1.44 .terraform.lock.hcl

# Validate the Configuration
terraform validate

# Plan the Configuration
terraform plan

# Apply the Configuration
terraform apply
```

**Observation:** Check `.terraform.lock.hcl` for:
1. Provider Version
2. Version Constraints
3. Hashes

---

## Step 5: Upgrade the Azure Provider Version
Upgrade the Azure provider to a newer version using the `-upgrade` flag.

### Steps:
1. Modify `c1-versions.tf`:
   ```hcl
   # Comment version 1.44.0 and Uncomment ">= 2.0"
   #version = "1.44.0"
   version = ">= 2.0"
   ```

2. Upgrade the provider:
   ```bash
   terraform init -upgrade
   ```

3. Backup the new lock file:
   ```bash
   cp .terraform.lock.hcl terraform.lock.hcl-V2.X.X
   ```

### Review:
Compare `.terraform.lock.hcl-v1.44` with `terraform.lock.hcl-V2.X.X`.

---

## Step 6: Run Terraform Apply with Latest Azure Provider
Attempt to apply the updated configuration. An error is expected due to the removal of the `account_encryption_source` argument in Azure Provider v2.x.

### Commands:
```bash
terraform plan
terraform apply
```

**Error Example**:
```log
Error: Unsupported argument
  on c2-resource-group-storage-container.tf line 21, in resource "azurerm_storage_account" "mysa":
  21: account_encryption_source = "Microsoft.Storage"
An argument named "account_encryption_source" is not expected here.
```

---

## Step 7: Fix Issues from Major Version Upgrades
1. **Comment Out the Unsupported Argument**:
   ```hcl
   # account_encryption_source = "Microsoft.Storage"
   ```
2. **Uncomment or Add the `features {}` Block**:
   ```hcl
   provider "azurerm" {
     features {}
   }
   ```

---

## Step 8: Run Terraform Plan and Apply
Run the updated configuration to ensure compatibility with the latest provider version.

```bash
terraform plan
terraform apply
```

---

## Step 9: Clean-Up
Remove all resources and cleanup files.

```bash
# Destroy Resources
terraform destroy

# Delete Terraform Files
rm -rf .terraform .terraform.lock.hcl terraform.tfstate*
```

**Note:** Retain `.terraform.lock.hcl-v1.44` and `.terraform.lock.hcl-V2.X.X` for demo purposes.

---

## Step 10: Restore to Original State
Revert changes for a seamless demo:
1. Reset `c1-versions.tf`:
   ```hcl
   version = "1.44.0"
   #version = ">= 2.0"
   ```
2. Comment out the `features {}` block.
3. Re-add the `account_encryption_source` attribute.

---

## References
- [Random Pet Provider](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet)
- [Dependency Lock File Documentation](https://www.terraform.io/docs/configuration/dependency-lock.html)
- [Terraform v0.14 New Features](https://learn.hashicorp.com/tutorials/terraform/provider-versioning?in=terraform/0-14) 

--- 
