# Terraform Input Variables Basics

**Description:** Learn the fundamentals of Terraform Input Variables, how to define them, and integrate them into resource configurations for flexibility and reusability.

---

## Step-01: Introduction

### **What are Terraform Input Variables?**
- Terraform Input Variables allow you to parameterize configurations.
- They make configurations dynamic, reusable, and flexible by enabling values to be passed during runtime.

### **Ways to Define Input Variables:**
1. **Variable Blocks in Configuration Files (`.tf`):**
   - Variables are defined in `*.tf` files, such as `variables.tf`.
2. **Environment Variables:**
   - Prefix `TF_VAR_` with variable names.
3. **CLI Flags:**
   - Use `-var` or `-var-file` flags during `terraform plan` and `terraform apply`.

---

## Step-02: Input Variables Basics

### **Terraform Files:**
- **`c1-versions.tf`:** Specifies required providers and versions.
- **`c2-variables.tf`:** Defines all input variables.
- **`c3-resource-group.tf`:** Uses input variables in the Azure Resource Group resource.
- **`c4-virtual-network.tf`:** Uses input variables in the Azure Virtual Network resource.

### **Input Variables Definition (`c2-variables.tf`):**
Define the following variables:

```hcl
# Input Variables

# 1. Business Unit Name
variable "business_unit" {
  description = "Business Unit Name"
  type        = string
  default     = "hr"
}

# 2. Environment Name
variable "environment" {
  description = "Environment Name"
  type        = string
  default     = "dev"
}

# 3. Resource Group Name
variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
  default     = "myrg"
}

# 4. Resource Group Location
variable "resource_group_location" {
  description = "Resource Group Location"
  type        = string
  default     = "East US"
}

# 5. Virtual Network Name
variable "virtual_network_name" {
  description = "Virtual Network Name"
  type        = string
  default     = "myvnet"
}
```

---

## Step-03: Use Variables in Resources - Resource Group (`c3-resource-group.tf`)

```hcl
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  name     = "${var.business_unit}-${var.environment}-${var.resource_group_name}"
  location = var.resource_group_location
}
```

---

## Step-04: Use Variables in Resources - Virtual Network (`c4-virtual-network.tf`)

```hcl
# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
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

3. **Format Configuration Files:**
   ```bash
   terraform fmt
   ```

4. **Plan the Configuration:**
   ```bash
   terraform plan
   ```

5. **Apply the Configuration:**
   ```bash
   terraform apply -auto-approve
   ```

### **Verify:**
1. Check the **Resource Group Name** in the Azure Management Console.
   - Example: `hr-dev-myrg`
2. Check the **Virtual Network Name** in the Azure Management Console.
   - Example: `hr-dev-myvnet`

---

## Step-06: Clean-Up

### Steps:
1. **Destroy Resources:**
   ```bash
   terraform destroy -auto-approve
   ```

2. **Clean Up Terraform Files:**
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   ```

---

## Summary

- Terraform Input Variables provide flexibility and make configurations reusable.
- Variables are integrated into resource definitions using the `var.<variable_name>` syntax.
- Using variables reduces hardcoding and enhances modularity.

---

## References
- [Terraform Input Variables Documentation](https://www.terraform.io/docs/language/values/variables.html)
