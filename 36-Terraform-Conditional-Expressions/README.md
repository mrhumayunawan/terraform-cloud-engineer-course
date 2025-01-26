# Terraform Conditional Expressions

**Description:** Learn how to use conditional expressions in Terraform to create dynamic and flexible configurations.

---

## Step-01: Introduction

### Overview:
- Understand and implement [Terraform Conditional Expressions](https://www.terraform.io/docs/language/expressions/conditionals.html).
- **Definition:** A conditional expression evaluates a boolean condition to select between two values.
  
#### Syntax Examples:
```hcl
# Basic Syntax
condition ? true_value : false_value

# Example Usage
var.a != "" ? var.a : "default-value"
```

---

## Step-02: Define Input Variables (`c2-variables.tf`)

### Updates to Input Variables:
In addition to the variables defined previously, new variables have been added for demonstration purposes:
```hcl
# Virtual Network Address for Dev Environment
variable "vnet_address_space_dev" {
  description = "Virtual Network Address Space for Dev Environment"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

# Virtual Network Address for All Other Environments
variable "vnet_address_space_all" {
  description = "Virtual Network Address Space for All Other Environments"
  type        = list(string)
  default     = ["10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16"]
}
```

---

## Step-03: Define Local Values (`c3-local-values.tf`)

### Add Conditional Expressions in Local Values:
```hcl
locals {
  # Simplify long names for readability
  rg_name   = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  vnet_name = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"

  # Common tags for all resources
  service_name = "Demo Services"
  owner        = "Kalyan Reddy Daida"
  common_tags  = {
    Service = local.service_name
    Owner   = local.owner
  }

  # Conditional Expression for Virtual Network Address Space
  vnet_address_space = var.environment == "dev" 
    ? var.vnet_address_space_dev 
    : var.vnet_address_space_all
}
```

---

## Step-04: Update Virtual Network Resource (`c5-virtual-network.tf`)

### Reference Local Value for Address Space:
```hcl
resource "azurerm_virtual_network" "myvnet" {
  name                = local.vnet_name
  address_space       = local.vnet_address_space
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags                = local.common_tags
}
```

---

## Step-05: Execute Terraform Commands

### Steps:
1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **Validate Configuration:**
   ```bash
   terraform validate
   ```

3. **Plan the Configuration:**
   - **For `dev` environment:**
     ```bash
     terraform plan
     ```
     **Observation:** Single address space is generated.
   - **For `qa` environment:**
     ```bash
     terraform plan
     ```
     **Observation:** Three address spaces are generated.

4. **Apply the Configuration (Optional):**
   ```bash
   terraform apply -auto-approve
   ```

---

## Step-06: Conditional Expressions in Resource Configuration

### Example: Conditional Resource Count
```hcl
resource "azurerm_virtual_network" "myvnet2" {
  count               = var.environment == "dev" ? 1 : 5
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}-${count.index}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
  tags                = local.common_tags
}
```

### Observations:
- **For `dev` environment:** Single virtual network is created.
- **For `qa` environment:** Five virtual networks are created.

---

## Step-07: Clean-Up

### Commands:
1. **Destroy Resources:**
   ```bash
   terraform destroy -auto-approve
   ```

2. **Remove Files:**
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   ```

3. **Reset Input Variables:**
   - In `c2-variables.tf`, set `environment` default back to `dev` for demo readiness.

---
