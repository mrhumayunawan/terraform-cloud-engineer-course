# Terraform Resource Meta-Argument `for_each` with `toset`

**Description:** Learn how to use Terraform's `for_each` meta-argument with the `toset` function to efficiently manage resources. This guide explains `toset`, its behavior, and how to implement it with a set of strings.

---

## Step-01: Introduction
- Understand Terraform's `for_each` meta-argument.
- Implement `for_each` with **Set of Strings** using the `toset` function.
- Relevant documentation:
  - [Resource Meta-Argument: for_each](https://www.terraform.io/docs/language/meta-arguments/for_each.html)
  - [toset Function](https://www.terraform.io/docs/language/functions/toset.html)

---

## Step-02: Terraform `toset()` Function

### **What is `toset`?**
- `toset` converts its argument into a **set** collection, ensuring:
  - All elements are of the same type.
  - Duplicate values are removed.
  - The collection is unordered (no specific order of elements).

### **Key Notes:**
1. **Single Type Only:** Mixed types in the input are converted to the most general type (e.g., numbers become strings if mixed with strings).
2. **Duplicate Removal:** Duplicates are coalesced into a single entry.
3. **Unordered Collection:** The order of elements is not preserved.

### **Examples in Terraform Console:**
```hcl
# Example 1: All strings
toset(["eastus", "westus", "eastus2"])

# Example 2: Mixed types (numbers converted to strings)
toset(["eastus", 123, 456])

# Example 3: Removing duplicates
toset(["eastus", "westus", "eastus", "eastus2"])

# Example 4: Unordered set
toset([4, 100, 20, 11, 4, 100])
```

---

## Step-03: `c1-versions.tf` Configuration

```hcl
# Terraform Block
terraform {
  required_version = ">= 1.0.0"
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

## Step-04: `c2-resource-group.tf` with `for_each` and `toset`

```hcl
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  for_each = toset(["eastus", "eastus2", "westus"]) # Set of regions
  name     = "myrg-${each.value}"                  # Resource group name
  location = each.value                            # Location based on each value
}
```

### **Explanation:**
1. **`for_each` Argument:**
   - Uses `toset` to convert the list `["eastus", "eastus2", "westus"]` into a set.
   - Iterates over each region in the set.
2. **`each.value`:**
   - Represents the current region (e.g., `eastus`).
   - Used in both the `name` and `location` fields.

---

## Step-05: Execute Terraform Commands

### **1. Initialize Terraform**
```bash
terraform init
```

### **2. Validate Configuration**
```bash
terraform validate
```

### **3. Format Configuration**
```bash
terraform fmt
```

### **4. Plan the Configuration**
```bash
terraform plan
```

**Observations:**
1. Terraform will plan to create 3 resource groups.
2. Resource names will be displayed as:
   ```
   azurerm_resource_group.myrg["eastus"]
   azurerm_resource_group.myrg["eastus2"]
   azurerm_resource_group.myrg["westus"]
   ```

### **5. Apply the Configuration**
```bash
terraform apply
```

**Observations:**
1. Three Azure Resource Groups will be created with names:
   - `myrg-eastus`
   - `myrg-eastus2`
   - `myrg-westus`
2. Verify these resource groups in the Azure Management Console.

### **6. Destroy the Resources**
```bash
terraform destroy
```

---

## Step-06: Clean-Up
Remove Terraform-generated files after destroying the resources.

```bash
rm -rf .terraform*
rm -rf terraform.tfstate*
```

---

## Summary

Using the `for_each` meta-argument with `toset`, you can dynamically create multiple resources based on a set of strings. The `toset` function ensures duplicates are removed, elements are of the same type, and ordering is irrelevant. This approach simplifies the creation of resources, particularly when working with dynamic collections.
