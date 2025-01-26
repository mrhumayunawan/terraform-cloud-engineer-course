# Terraform Output Values Basics

**Description:** Learn the basics of Terraform output values, including their use, querying, and handling sensitive data.

---

## Step-01: Introduction

- **Output Values** provide information about resources after Terraform applies changes.
- Use cases:
  - Query outputs using `terraform output`.
  - Redact secure attributes from output values.
  - Generate machine-readable output.
  - Export both argument and attribute references.
- **Sensitive Outputs:** Use `sensitive = true` to redact output values in CLI.

---

## Step-02: Terraform Configuration (`c1-versions.tf`)

```hcl
terraform {
  required_version = ">= 1.0.0"
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

## Step-03: Input Variables (`c2-variables.tf`)

Define variables for business unit, environment, resource group, and virtual network:
```hcl
variable "business_unit" {
  description = "Business Unit Name"
  type        = string
  default     = "hr"
}

variable "environment" {
  description = "Environment Name"
  type        = string
  default     = "poc"
}

variable "resoure_group_name" {
  description = "Resource Group Name"
  type        = string
  default     = "myrg"
}

variable "resoure_group_location" {
  description = "Resource Group Location"
  type        = string
  default     = "East US"
}

variable "virtual_network_name" {
  description = "Virtual Network Name"
  type        = string
  default     = "myvnet"
}
```

---

## Step-04: Azure Resource Group (`c3-resource-group.tf`)

```hcl
resource "azurerm_resource_group" "myrg" {
  name     = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  location = var.resoure_group_location
}
```

---

## Step-05: Azure Virtual Network (`c4-virtual-network.tf`)

```hcl
resource "azurerm_virtual_network" "myvnet" {
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}
```

---

## Step-06: Input Values (`terraform.tfvars`)

```hcl
business_unit         = "it"
environment           = "dev"
resoure_group_name    = "rg"
virtual_network_name  = "vnet"
```

---

## Step-07: Output Values (`c5-outputs.tf`)

Define output values for resource group and virtual network:
```hcl
# Resource Group Outputs
output "resource_group_id" {
  description = "Resource Group ID"
  value       = azurerm_resource_group.myrg.id
}

output "resource_group_name" {
  description = "Resource Group Name"
  value       = azurerm_resource_group.myrg.name
}

# Virtual Network Outputs
output "virtual_network_name" {
  description = "Virtual Network Name"
  value       = azurerm_virtual_network.myvnet.name
}
```

---

## Step-08: Execute Terraform Commands

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **Validate Configuration:**
   ```bash
   terraform validate
   ```

3. **Format Files:**
   ```bash
   terraform fmt
   ```

4. **Plan and Apply:**
   ```bash
   terraform plan
   terraform apply -auto-approve
   ```

### Observation:
- Verify outputs in the CLI.

---

## Step-09: Query Terraform Outputs

- Terraform stores state in the `.tfstate` file, which can be queried using `terraform output`.

### Commands:
```bash
terraform output
terraform output resource_group_id
terraform output virtual_network_name
```

---

## Step-10: Redact Sensitive Values

- Add `sensitive = true` to the output block for `virtual_network_name`.

```hcl
output "virtual_network_name" {
  description = "Virtual Network Name"
  value       = azurerm_virtual_network.myvnet.name
  sensitive   = true
}
```

### Test:
1. **Apply Configuration:**
   ```bash
   terraform apply -auto-approve
   ```
   **Observation:** The value is redacted in the CLI output.

2. **Query Using `terraform output`:**
   ```bash
   terraform output virtual_network_name
   ```
   **Observation:** Original value is retrieved from the state file.

---

## Step-11: Generate Machine-Readable Output

Generate outputs in JSON format:
```bash
terraform output -json
```

---

## Step-12: Clean-Up

1. **Destroy Resources:**
   ```bash
   terraform destroy -auto-approve
   ```

2. **Remove Files:**
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   ```

3. **Rollback Sensitive Flag:**
   ```hcl
   # Rollback to original state
   output "virtual_network_name" {
     description = "Virtual Network Name"
     value       = azurerm_virtual_network.myvnet.name
   }
   ```

---

## References

- [Terraform Output Values](https://www.terraform.io/docs/language/values/outputs.html)
