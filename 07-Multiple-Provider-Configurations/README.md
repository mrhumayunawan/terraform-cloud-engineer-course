# Terraform Multiple Provider Blocks on Azure Cloud

**Description:** Learn how to use and configure multiple Terraform provider blocks on Azure Cloud to manage resources in different regions or customize provider behavior.

---

## Step 1: Introduction

Gain a clear understanding of how to define and implement multiple provider configurations in Terraform. This approach is especially useful for managing resources across different regions or with varying provider-specific settings.

---

## Step 2: Defining Multiple Provider Configurations for the Same Provider

Terraform allows you to define multiple configurations for the same provider by assigning aliases to non-default providers.

### Example Configuration:

#### Default Provider (East US):
```hcl
provider "azurerm" {
  features {}
}
```

#### Additional Provider (West US):
```hcl
provider "azurerm" {
  features {
    virtual_machine {
      delete_os_disk_on_deletion = false # Retains the OS disk even when the VM is destroyed
    }
  }
  alias = "provider2-westus"
  # Optional parameters
  # client_id       = "XXXX"
  # client_secret   = "YYYY"
  # environment     = "german"
  # subscription_id = "JJJJ"
}
```

---

## Step 3: Referencing Non-Default Providers in Resources

Use the `provider` argument in a resource block to explicitly reference a non-default provider configuration.

### Example:
```hcl
# Resource Group in West US Region (Uses the "provider2-westus" configuration)
resource "azurerm_resource_group" "myrg2" {
  name     = "myrg-2"
  location = "West US"
  provider = azurerm.provider2-westus # Reference the non-default provider
}
```

---

## Step 4: Execute Terraform Commands

Follow these steps to initialize and apply the configuration:

```bash
# Initialize Terraform
terraform init

# Validate the configuration files
terraform validate

# Generate and review the Terraform plan
terraform plan

# Apply the configuration to create resources
terraform apply -auto-approve
```

### Verification:
1. Verify the resource group created in the **East US** region (default provider).
2. Verify the resource group created in the **West US** region (non-default provider).

---

## Step 5: Clean-Up

Remove all resources and Terraform files to avoid unnecessary costs:

```bash
# Destroy all resources
terraform destroy -auto-approve

# Delete Terraform state and temporary files
rm -rf .terraform*
rm -rf terraform.tfstate*
```

---

## References

- [Provider Meta Argument Documentation](https://www.terraform.io/docs/configuration/meta-arguments/resource-provider.html)
- [Azure Provider Argument and Attribute References](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

---
