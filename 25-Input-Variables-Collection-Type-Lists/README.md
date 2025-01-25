# Terraform Input Variables with Collection Type Lists

**Description:** Learn how to use Terraform input variables of collection type `list` to manage complex configurations like virtual network address spaces.

---

## Step-01: Introduction

- Explore the use of complex type constructors such as `list` in Terraform.
- Define and implement a `list` type variable to handle multiple values like address spaces in a virtual network.

---

## Step-02: Implementing `list` Type Variables

### Key Features:
- **Type Constraints:** Terraform supports type constraints like `list` and `tuple`. A `list` is a sequence of values identified by indices starting from zero.
- Use the `list` type for variables like `virtual_network_address_space`.

### Example: Defining a `list` Variable

#### `c2-variables.tf`
```hcl
# Virtual Network Address Space
variable "virtual_network_address_space" {
  description = "Virtual Network Address Space"
  type        = list(string)
  default     = ["10.0.0.0/16", "10.1.0.0/16", "10.2.0.0/16"]
}
```

#### `terraform.tfvars`
```hcl
business_unit               = "it"
environment                 = "dev"
resoure_group_name          = "rg-list"
resoure_group_location      = "eastus2"
virtual_network_name        = "vnet-list"
subnet_name                 = "subnet-list"
virtual_network_address_space = ["10.3.0.0/16", "10.4.0.0/16", "10.5.0.0/16"]
```

---

## Step-03: Updating Terraform Configuration for `list` Variable

### Update Virtual Network Configuration

#### `c4-virtual-network.tf`
```hcl
# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  address_space       = var.virtual_network_address_space
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}
```

### Update Subnet Configuration

```hcl
# Create Subnet
resource "azurerm_subnet" "mysubnet" {
  name                 = "${azurerm_virtual_network.myvnet.name}-${var.subnet_name}"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.3.0.0/24"]
}
```

---

## Step-04: Execute Terraform Commands

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **Validate Configuration Files:**
   ```bash
   terraform validate
   ```

3. **Format Configuration Files:**
   ```bash
   terraform fmt
   ```

4. **Review and Apply Plan:**
   ```bash
   terraform plan
   terraform apply -auto-approve
   ```

### Observations:
- Check the Azure Management Console.
- Verify the Virtual Network with three address spaces.

---

## Step-05: Referencing List Values Individually

### Examples:
```hcl
# Access individual list values
var.virtual_network_address_space[0]
var.virtual_network_address_space[1]
var.virtual_network_address_space[2]

# Use a single value in configuration
address_space = [var.virtual_network_address_space[0]]
```

---

## Step-06: Limiting Address Spaces to a Single Value

### Updated Virtual Network Configuration

#### `c4-virtual-network.tf`
```hcl
# Create Virtual Network with a single address space
resource "azurerm_virtual_network" "myvnet" {
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}"
  address_space       = [var.virtual_network_address_space[0]]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}
```

---

## Step-07: Execute Updated Configuration

1. **Review Plan:**
   ```bash
   terraform plan
   ```

2. **Apply Configuration:**
   ```bash
   terraform apply -auto-approve
   ```

### Observations:
- Verify the Virtual Network in Azure Management Console.
- Confirm only one address space is configured for the VNet.

---

## Step-08: Clean-Up and Rollback

1. **Destroy Resources:**
   ```bash
   terraform destroy -auto-approve
   ```

2. **Clean Up Files:**
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   ```

3. **Rollback Configuration:**
   - Re-enable the full address space configuration:
     ```hcl
     address_space = var.virtual_network_address_space
     ```

---

## References

- [Terraform Input Variables Documentation](https://www.terraform.io/docs/language/values/variables.html)
