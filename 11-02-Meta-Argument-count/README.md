---

# Terraform Resource Meta-Argument Count

**Description:** Learn the Terraform Resource Meta-Argument `count` and how it simplifies resource provisioning for repetitive tasks. This guide provides examples and practical steps to implement the `count` argument.

---

## Step-01: Introduction
- Learn about the [Resources: Count Meta-Argument](https://www.terraform.io/docs/language/meta-arguments/count.html).
- Understand the `count` meta-argument for Terraform resources.
- Implement `count` and `count.index` practically.
- Example:
  - 1 Azure VM Instance Resource in Terraform = 1 Azure VM Instance in the Azure Cloud.
  - 5 Azure VM Instance Resources = 5 Azure VM Instances in the Azure Cloud.
- With the `count` meta-argument, provisioning becomes much simpler.
- Learn additional concepts:
  - [Terraform element Function](https://www.terraform.io/docs/language/functions/element.html)
  - [Terraform Splat Expression](https://www.terraform.io/docs/language/expressions/splat.html)
  - [Terraform Length Function](https://www.terraform.io/docs/language/functions/length.html)
  - [Terraform Console](https://www.terraform.io/docs/cli/commands/console.html)

---

## Step-02: Simple Example - Review `terraform-manifests-v1`
- Folder Path: `terraform-manifests-v1`
- Files:
  - `c1-versions.tf`
  - `c2-resource-group.tf`

### Example Resource
```hcl
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  name     = "myrg-${count.index}"
  location = "East US"
  count    = 3
}
```

---

## Step-03: Execute Terraform Commands
```bash
# Change Directory
cd terraform-manifests-v1

# Initialize Terraform
terraform init

# Validate Configuration
terraform validate

# Review Plan
terraform plan

# Apply Changes
terraform apply

# Destroy Resources
terraform destroy -auto-approve
```

**Verification:**
1. Three Resource Groups will be created.
2. Observe the `count.index` for each resource group.

---

## Step-04: Review Terraform Configs V2
**Use Case:** Create two Azure Linux VMs using the `count` meta-argument.

### Requirements:
1. Two Public IPs for two VMs.
2. Two Network Interfaces for two VMs.

### Additional Concepts:
- [Terraform Console](https://www.terraform.io/docs/cli/commands/console.html)
- [Terraform Length Function](https://www.terraform.io/docs/language/functions/length.html)
- [Terraform Element Function](https://www.terraform.io/docs/language/functions/element.html)
- [Terraform Splat Expression](https://www.terraform.io/docs/language/expressions/splat.html)

**Folder Path:** `terraform-manifests-v2`

---

## Step-05: Configure `c3-virtual-network.tf`
Add `count=2` to the Public IP resource.

```hcl
# Create Azure Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  count               = 2
  name                = "mypublicip-${count.index}"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label   = "app1-vm-${count.index}-${random_string.myrandom.id}"
}
```

---

## Step-06: Understand Splat Expression
Learn about [Terraform Splat Expression](https://www.terraform.io/docs/language/expressions/splat.html) and the `element` function.

```bash
# Use Terraform Console
terraform console
element(["alice", "bob", "carol"], 0)
element(["alice", "bob", "carol"], 1)
element(["alice", "bob", "carol"], 2)

# Get the last element from a list
length(["alice", "bob", "carol"])
element(["alice", "bob", "carol"], length(["alice", "bob", "carol"]) - 1)
```

---

## Step-07: Update Network Interface in `c3-virtual-network.tf`
Add `count=2` and associate Public IPs.

```hcl
# Create Network Interface
resource "azurerm_network_interface" "myvmnic" {
  count               = 2
  name                = "vmnic-${count.index}"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.mypublicip[*].id, count.index)
  }
}
```

---

## Step-08: Update Linux VM Configuration in `c4-linux-virtual-machine.tf`
Add `count=2` to the Linux VM resource.

```hcl
# Resource: Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  count = 2
  name                = "mylinuxvm-${count.index}"
  computer_name       = "devlinux-${count.index}"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [element(azurerm_network_interface.myvmnic[*].id, count.index)]
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    name                 = "osdisk${count.index}"
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

## Step-09: Execute Terraform Commands
```bash
# Change Directory
cd terraform-manifests-v2

# Initialize Terraform
terraform init

# Validate Configuration
terraform validate

# Review Plan
terraform plan

# Apply Changes
terraform apply
```

**Verification:**
1. Two Public IPs.
2. Two Network Interfaces.
3. Two Linux Virtual Machines.

**Access Applications:**
- `http://<PUBLIC_IP-1>`
- `http://<PUBLIC_IP-2>`

---

## Step-10: Clean Up Resources
```bash
# Destroy Terraform Resources
terraform destroy

# Remove Terraform Files
rm -rf .terraform*
rm -rf terraform.tfstate*
```

---

## References
- [Resources: Count Meta-Argument](https://www.terraform.io/docs/language/meta-arguments/count.html)

---

