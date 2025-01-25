# Terraform Resource Syntax, Behavior, and State

**Description:** Explore the foundational concepts of Terraform resource syntax, behavior, and state management. Learn how Terraform interacts with cloud resources, manages changes, and tracks their states.

---

## Step 1: Introduction

In this section, we will cover:
- Resource syntax and its structure.
- Resource behavior during create, update, and delete operations.
- Terraform state file (`terraform.tfstate`) and its significance.
- An overview of desired and current states.

---

## Step 2: Understanding Resource Syntax

Key concepts to understand from a resource syntax perspective:
1. **Resource Block**: Defines the resource type and its configuration.
2. **Resource Type**: Specifies the type of resource (e.g., `azurerm_virtual_network`).
3. **Resource Local Name**: Provides a local identifier for the resource.
4. **Resource Arguments**: Configurable properties of the resource.
5. **Resource Meta-Arguments**: Special arguments like `depends_on`, `count`, and `lifecycle`.

---

## Step 3: Example Configuration - `c1-versions.tf`

### Terraform and Provider Block:
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

## Step 4: Example Configuration - Resource Group (`c2-resource-group.tf`)

### Create Azure Resource Group:
```hcl
resource "azurerm_resource_group" "myrg" {
  name     = "myrg-1"
  location = "East US"
}
```

---

## Step 5: Additional Resources - Virtual Network and Related Resources (`c3-virtual-network.tf`)

### Resources:
1. **Virtual Network**:
   ```hcl
   resource "azurerm_virtual_network" "myvnet" {
     name                = "myvnet-1"
     address_space       = ["10.0.0.0/16"]
     location            = azurerm_resource_group.myrg.location
     resource_group_name = azurerm_resource_group.myrg.name
   }
   ```

2. **Subnet**:
   ```hcl
   resource "azurerm_subnet" "mysubnet" {
     name                 = "mysubnet-1"
     resource_group_name  = azurerm_resource_group.myrg.name
     virtual_network_name = azurerm_virtual_network.myvnet.name
     address_prefixes     = ["10.0.2.0/24"]
   }
   ```

3. **Public IP Address**:
   ```hcl
   resource "azurerm_public_ip" "mypublicip" {
     name                = "mypublicip-1"
     resource_group_name = azurerm_resource_group.myrg.name
     location            = azurerm_resource_group.myrg.location
     allocation_method   = "Static"

     tags = {
       environment = "Dev"
     }
   }
   ```

4. **Network Interface**:
   ```hcl
   resource "azurerm_network_interface" "myvm1nic" {
     name                = "vm1-nic"
     location            = azurerm_resource_group.myrg.location
     resource_group_name = azurerm_resource_group.myrg.name

     ip_configuration {
       name                          = "internal"
       subnet_id                     = azurerm_subnet.mysubnet.id
       private_ip_address_allocation = "Dynamic"
       public_ip_address_id          = azurerm_public_ip.mypublicip.id
     }
   }
   ```

---

## Step 6: Understanding Resource Behavior

Terraform resource behavior works in conjunction with the state file. Key behaviors include:
1. **Create Resource**: Resources are created when they do not exist in the state file or cloud.
2. **Update In-Place**: Changes to existing resources are applied without destroying them.
3. **Destroy and Re-Create**: Resources are destroyed and recreated when critical properties (e.g., resource name) are modified.
4. **Destroy Resource**: Resources are removed from both the state file and the cloud when deleted.

---

## Step 7: Creating Resources

### Commands:
```bash
# Initialize Terraform
terraform init

# Validate Configuration
terraform validate

# Format Configuration Files
terraform fmt

# Review Plan
terraform plan

# Apply Configuration
terraform apply -auto-approve
```

**Observation**:
1. A `.terraform.lock.hcl` file and `.terraform` directory are created.
2. The `terraform.tfstate` file is created after the first `apply`.
3. Resources are created in Azure Cloud.

---

## Step 8: Understanding Terraform State File

### Key Points:
1. Terraform state is the database for managing resource information.
2. It maps remote objects to resource instances in the configuration.
3. The state file is created locally during the first `terraform apply`.
4. Remote storage for state files is recommended for collaboration.

---

## Step 9: Updating Resources In-Place

### Example:
Add a new tag to the Virtual Network resource:
```hcl
tags = {
  Environment = "Dev"
}
```

### Commands:
```bash
# Review Plan
terraform plan

# Apply Changes
terraform apply -auto-approve
```

**Observation**: Changes are applied without recreating the resource (`~ update in-place`).

---

## Step 10: Destroy and Re-Create Resources

Modify a critical property (e.g., resource name) to force a destroy and recreate.

### Commands:
```bash
# Review Plan
terraform plan

# Apply Changes
terraform apply -auto-approve
```

**Observation**: Resources are destroyed and recreated (`-/+` indicates replacement).

---

## Step 11: Destroying Resources

### Command:
```bash
terraform destroy -auto-approve
```

**Observation**: All resources are removed from Azure Cloud and the state file.

---

## Step 12: Desired vs. Current States

1. **Desired State**: Defined in the `.tf` files (local configuration).
2. **Current State**: Actual resources deployed in the cloud.

---

## Step 13: Clean-Up

### Commands:
```bash
# Destroy Resources
terraform destroy -auto-approve

# Remove Terraform Files
rm -rf .terraform* terraform.tfstate*
```

---

## Step 14: Reset Files for Demo

1. Revert changes to the Virtual Network (`tags`).
2. Reset resource names or other changes.

---

## References
- [Terraform State Documentation](https://www.terraform.io/docs/language/state/index.html)
- [Terraform CLI State Commands](https://www.terraform.io/docs/cli/state/index.html)

--- 
