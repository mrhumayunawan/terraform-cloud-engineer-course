# Terraform Resource Meta-Argument `for_each` with Maps

**Description:** Learn how to use Terraform's `for_each` meta-argument with maps to efficiently create multiple resources. This guide provides step-by-step instructions to implement and execute `for_each` with maps.

---

## Step-01: Introduction
- **Objective:** Understand and implement the Terraform `for_each` meta-argument with maps.
- The `for_each` meta-argument enables the creation of multiple resources by iterating over a collection (e.g., maps or sets).
- Official Documentation: [Resource Meta-Argument: for_each](https://www.terraform.io/docs/language/meta-arguments/for_each.html)

---

## Step-02: Create `c1-versions.tf`
Define the Terraform and provider configuration.

```hcl
# Terraform Block
terraform {
  required_version = ">= 0.15"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
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

## Step-03: Create `c2-resource-group.tf` with `for_each` and Maps
Use the `for_each` meta-argument to dynamically create multiple Azure resource groups.

```hcl
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  for_each = {
    dc1apps = "eastus"
    dc2apps = "eastus2"
    dc3apps = "westus"
  }
  name     = "${each.key}-rg"
  location = each.value
}
```

### Explanation:
- **`for_each`:** Iterates over the map (`{dc1apps, dc2apps, dc3apps}`) to create resources.
- **`each.key`:** Provides the key from the map (e.g., `dc1apps`).
- **`each.value`:** Provides the value from the map (e.g., `eastus`).
- **Resource Name:** Uses `each.key` to dynamically set the name of the resource group (e.g., `dc1apps-rg`).

---

## Step-04: Execute Terraform Commands

### Initialize Terraform
```bash
terraform init
```

### Validate Configuration
```bash
terraform validate
```

### Format Configuration Files
```bash
terraform fmt
```

### Plan the Configuration
```bash
terraform plan
```

**Observations:**
1. Terraform will plan to create 3 resource groups.
2. Resource names will appear in the plan as:
   ```
   azurerm_resource_group.myrg["dc1apps"]
   azurerm_resource_group.myrg["dc2apps"]
   azurerm_resource_group.myrg["dc3apps"]
   ```

### Apply the Configuration
```bash
terraform apply
```

**Observations:**
1. Three Azure resource groups will be created.
2. Resource group names in Azure:
   - `dc1apps-rg` in `eastus`.
   - `dc2apps-rg` in `eastus2`.
   - `dc3apps-rg` in `westus`.

### Destroy the Resources
```bash
terraform destroy
```

**Observations:**
- All three resource groups will be destroyed.

---

## Step-05: Clean-Up
Remove local Terraform files after destroying the resources.

```bash
rm -rf .terraform*
rm -rf terraform.tfstate*
```

---

## Summary
Using the `for_each` meta-argument with maps, you can dynamically create multiple resources in Terraform based on key-value pairs. This approach is efficient, scalable, and reduces repetitive code.

---

