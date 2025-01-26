# Terraform Input Variables with Collection Type `set`

**Description:** Learn how to use Terraform input variables of type `set` to create resources dynamically for multiple environments using a single set of templates.

---

## Step-01: Introduction

- **Set Type:** A collection of unique elements with no guaranteed order.
- Sets are particularly useful when traversing resources in loops, such as with `for_each`.
- In this example, we create the following resources for multiple environments (`dev`, `qa`, `staging`, `prod`) using a `set` and `for_each` combination:
  1. Resource Group
  2. Virtual Network
  3. Subnet
  4. Public IP & Public Azure DNS Name
  5. Network Interface
  6. RHEL Virtual Machine
  7. Sample Webserver on the RHEL VM

---

## Step-02: Define Variable Type `set`

### Key Features:
1. Sets do not guarantee element ordering.
2. Repeated elements are automatically coalesced to ensure uniqueness.

#### Example:
```hcl
# Environment Variable (Set)
variable "environment" {
  description = "Environment Name"
  type        = set(string)
  default     = ["dev1", "qa1", "staging1", "prod1"]
}
```

---

## Step-03: Define Variables (`c2-variables.tf`)

Define the `environment` variable as a `set`:
```hcl
variable "environment" {
  description = "Environment Name"
  type        = set(string)
  default     = ["dev1", "qa1", "staging1", "prod1"]
}
```

---

## Step-04: Update `terraform.tfvars`

Customize the environments in `terraform.tfvars`:
```hcl
# Business Unit and Environments
business_unit = "it"
environment = ["dev2", "myqa2", "staging2", "prod2"]
resoure_group_name = "rg"
```

---

## Step-05: Create Resources with `for_each`

### Random String Resource (`c1-versions.tf`):
Generate random strings for each environment:
```hcl
resource "random_string" "myrandom" {
  for_each = var.environment
  length   = 6
  upper    = false
  special  = false
  number   = false
}
```

### Resource Group (`c3-resource-group.tf`):
Create a resource group for each environment:
```hcl
resource "azurerm_resource_group" "myrg" {
  for_each = var.environment
  name     = "${var.business_unit}-${each.key}-${var.resoure_group_name}"
  location = var.resoure_group_location
}
```

### Virtual Network (`c4-virtual-network.tf`):
Create a virtual network for each environment:
```hcl
resource "azurerm_virtual_network" "myvnet" {
  for_each           = var.environment
  name               = "${var.business_unit}-${each.key}-${var.virtual_network_name}"
  address_space      = ["10.0.0.0/16"]
  location           = azurerm_resource_group.myrg[each.key].location
  resource_group_name = azurerm_resource_group.myrg[each.key].name
}
```

---

## Step-06: Additional Resources

### Subnet:
Create a subnet for each virtual network:
```hcl
resource "azurerm_subnet" "mysubnet" {
  for_each            = var.environment
  name                = "${var.business_unit}-${each.key}-${var.virtual_network_name}-mysubnet"
  resource_group_name = azurerm_resource_group.myrg[each.key].name
  virtual_network_name = azurerm_virtual_network.myvnet[each.key].name
  address_prefixes    = ["10.0.2.0/24"]
}
```

### Public IP:
Create a public IP for each environment:
```hcl
resource "azurerm_public_ip" "mypublicip" {
  for_each = var.environment
  name     = "${var.business_unit}-${each.key}-${var.virtual_network_name}-mypublicip"
  resource_group_name = azurerm_resource_group.myrg[each.key].name
  location            = azurerm_resource_group.myrg[each.key].location
  allocation_method   = "Static"
  domain_name_label   = "app1-vm-${each.key}-${random_string.myrandom[each.key].id}"
}
```

### Network Interface:
Create a network interface for each environment:
```hcl
resource "azurerm_network_interface" "myvmnic" {
  for_each = var.environment
  name     = "${var.business_unit}-${each.key}-${var.virtual_network_name}-myvmnic"
  location = azurerm_resource_group.myrg[each.key].location
  resource_group_name = azurerm_resource_group.myrg[each.key].name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypublicip[each.key].id
  }
}
```

### Linux Virtual Machine:
Create a Linux VM for each environment:
```hcl
resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  for_each = var.environment
  name                = "mylinuxvm-${each.key}"
  resource_group_name = azurerm_resource_group.myrg[each.key].name
  location            = azurerm_resource_group.myrg[each.key].location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.myvmnic[each.key].id]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    name                 = "osdisk-${each.key}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "RedHat"
    offer     = "RHEL"
    sku       = "83-gen2"
    version   = "latest"
  }
  custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")
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

4. **Review the Plan:**
   ```bash
   terraform plan
   ```

5. **Apply Configuration:**
   ```bash
   terraform apply -auto-approve
   ```

### Observations:
- Verify resources for each environment:
  - Resource groups
  - Virtual networks
  - Subnets
  - Public IPs
  - Network interfaces
  - Virtual machines

---

## Step-08: Clean-Up

1. **Destroy Resources:**
   ```bash
   terraform destroy -auto-approve
   ```

2. **Remove Files:**
   ```bash
   rm -rf .terraform* terraform.tfstate*
   ```

---

## References

- [Terraform Input Variables Documentation](https://www.terraform.io/docs/language/values/variables.html)
- [Terraform Type Constraints Documentation](https://www.terraform.io/docs/language/expressions/types.html)
