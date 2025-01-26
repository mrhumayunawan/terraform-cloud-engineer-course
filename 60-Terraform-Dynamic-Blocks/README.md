# Terraform Dynamic Blocks

**Description:** Learn how to use **Terraform Dynamic Blocks** to efficiently manage repeatable nested blocks and simplify your Terraform configurations.

---

## Step-01: Introduction

### Key Points:
- **[Dynamic Block](https://www.terraform.io/docs/language/expressions/dynamic-blocks.html)**: A block type that allows you to dynamically construct repeatable nested blocks in Terraform configurations, especially for resource types that do not accept expressions.
- Some **resource types** include repeatable nested blocks (e.g., security rules in network security groups) that require a special **dynamic block type**.
- **[sum function](https://www.terraform.io/docs/language/functions/sum.html)** can be used within the **Terraform Console** to perform calculations in dynamic block logic.
- Example: **Azure Network Resource Group** configuration for managing network security groups: [Azure Network Resource Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group).

---

## Step-02: Review `c1-versions.tf`

This is a standard file without any changes, ensuring that the correct version of Terraform and the Azure provider are used.

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

## Step-03: Review `c2-resource-group.tf`

A simple configuration to define an Azure Resource Group.

```hcl
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  name     = "myrg-1"
  location = "East US"
}
```

---

## Step-04: Review `c3-network-security-group-regular.tf`

This example shows how to define a **Network Security Group (NSG)** with multiple **security_rule** blocks to allow inbound and outbound traffic.

```hcl
# Resource-2: Create Network Security Group
resource "azurerm_network_security_group" "mynsg" {
  name                = "mynsg-1"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  security_rule {
    name                       = "inbound-rule-1"
    description                = "Inbound SSH Rule"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "22"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "inbound-rule-2"
    description                = "Inbound HTTP Rule"    
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "80"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "inbound-rule-3"
    description                = "Inbound Tomcat Rule"    
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "8080"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "outbound-rule-1"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  } 
  tags = {
    environment = "Dev"
  }
}
```

---

## Step-05: Terraform Sum Function using Terraform Console

Use the `sum()` function in **Terraform Console** to perform simple arithmetic calculations:

```hcl
# Terraform Console
sum([100,1])
sum([100,2])
```

---

## Step-06: Review `c4-network-security-group-dynamic-block.tf`

This example demonstrates how to dynamically create multiple **security_rule** blocks based on a list of ports, using the **`dynamic`** block type in Terraform.

```hcl
# Define Ports as a list in locals block
locals {
  ports = [22, 80, 8080, 8081, 7080, 7081] 
}

# Resource-2: Create Network Security Group
resource "azurerm_network_security_group" "mynsg2" {
  name                = "mynsg-2"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  dynamic "security_rule" {
    for_each = local.ports 
    content {
      name                       = "inbound-rule-${security_rule.key}"
      description                = "Inbound Rule ${security_rule.key}"    
      priority                   = sum([100, security_rule.key])
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = security_rule.value
      destination_port_range     = security_rule.value
      source_address_prefix      = "*"
      destination_address_prefix = "*"      
    }
  }

  security_rule {
    name                       = "Outbound-rule-1"
    description                = "Outbound Rule"    
    priority                   = 102
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Dev"
  }  
}
```

---

## Step-07: Execute Terraform Commands

Run the standard Terraform commands to apply the configuration and manage infrastructure.

```bash
# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve
```

---

## Step-08: Clean-Up

Clean up the resources created by Terraform:

```bash
# Terraform Destroy
terraform destroy -auto-approve

# Delete Files
rm -rf .terraform*
rm -rf terraform.tfstate*
```

---
