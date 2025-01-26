# Terraform Local Values

**Description:** Learn about Terraform local values, their use cases, and how to implement them to adhere to the DRY principle and improve configuration readability.

---

## Step-01: Introduction

### Key Concepts

1. **DRY Principle:**
   - *Don't Repeat Yourself* – avoid duplicating values or expressions in Terraform configurations.

2. **Local Values in Terraform:**
   - `local` blocks define variables within a module, allowing you to reuse expressions without repetition.

3. **When to Use Local Values:**
   - Avoid repeating values or expressions multiple times in a configuration.
   - Simplify maintenance by centralizing values expected to change.
   - Enhance readability and avoid long expressions by creating short references.

4. **Problem Solved by Local Values:**
   - Terraform doesn't support variable substitution directly within variables.
   - Local values serve as intermediate variables, allowing DRY configurations.

---

## Step-02: Terraform Configuration (`c1-versions.tf`)

Define the Terraform and provider versions:
```hcl
terraform {
  required_version = ">= 0.15"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0"
    }
  }
}

provider "azurerm" {
  features {}
}
```

---

## Step-03: Define Input Variables (`c2-variables.tf`)

Input variables to define business unit, environment, resource group, and virtual network:
```hcl
# Business Unit Name
variable "business_unit" {
  description = "Business Unit Name"
  type        = string
  default     = "hr"
}

# Environment Name
variable "environment" {
  description = "Environment Name"
  type        = string
  default     = "dev"
}

# Resource Group Name
variable "resoure_group_name" {
  description = "Resource Group Name"
  type        = string
  default     = "myrg"
}

# Resource Group Location
variable "resoure_group_location" {
  description = "Resource Group Location"
  type        = string
  default     = "East US"
}

# Virtual Network Name
variable "virtual_network_name" {
  description = "Virtual Network Name"
  type        = string
  default     = "myvnet"
}
```

---

## Step-04: Define Local Values (`c3-local-values.tf`)

Local values to centralize expressions and reusable configurations:
```hcl
locals {
  # Use-Case 1: Simplify long names
  rg_name  = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  vnet_name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"

  # Use-Case 2: Common tags
  service_name = "Demo Services"
  owner        = "Mr Professor"
  common_tags = {
    Service = local.service_name
    Owner   = local.owner
  }

  # Use-Case 3: Complex or dynamic expressions (future use cases)
}
```

---

## Step-05: Resource Group Configuration (`c4-resource-group.tf`)

Define the resource group using local values:
```hcl
resource "azurerm_resource_group" "myrg" {
  name     = local.rg_name
  location = var.resoure_group_location
  tags     = local.common_tags
}
```

---

## Step-06: Virtual Network Configuration (`c5-virtual-network.tf`)

Define the virtual network using local values:
```hcl
resource "azurerm_virtual_network" "myvnet" {
  name                = local.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags                = local.common_tags
}
```

---

## Step-07: Execute Terraform Commands

### Steps:

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **Validate Configuration:**
   ```bash
   terraform validate
   ```

3. **Format Configuration Files:**
   ```bash
   terraform fmt
   ```

4. **Plan and Apply Configuration:**
   ```bash
   terraform plan
   terraform apply -auto-approve
   ```

### Observations:
1. **Resource Group:**
   - Name includes business unit, environment, and resource group.
   - Tags include `Service` and `Owner` (`Mr Professor`).

2. **Virtual Network:**
   - Name includes business unit, environment, and virtual network.
   - Tags are inherited from `common_tags`.

---

## Step-08: Clean-Up Resources

1. **Destroy Resources:**
   ```bash
   terraform destroy -auto-approve
   ```

2. **Remove Files:**
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   ```

---

## References

- [Terraform Local Values](https://www.terraform.io/docs/language/values/locals.html)
