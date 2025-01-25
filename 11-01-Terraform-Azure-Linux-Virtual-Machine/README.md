# Provision Azure Linux VM using Terraform

**Description:** Learn how to provision an Azure Linux Virtual Machine (VM) and its supporting resources using Terraform. This guide demonstrates the use of `custom_data` to configure a simple web server during VM creation.

---

## Step 1: Introduction
The following Azure resources will be created:
1. **Resource Group**
2. **Virtual Network**
3. **Subnet**
4. **Public IP**
5. **Network Interface**
6. **Linux Virtual Machine**
7. **Random String Resource**

Key features:
- Use `custom_data` in `azurerm_linux_virtual_machine` to configure a web server.
- Learn about Terraform file functions: [file](https://www.terraform.io/docs/language/functions/file.html) and [filebase64](https://www.terraform.io/docs/language/functions/filebase64.html).

---

## Step 2: Create SSH Keys for Azure Linux VM

### Commands:
```bash
# Create a directory for SSH keys
cd terraform-manifests/
mkdir ssh-keys

# Generate SSH keys
ssh-keygen \
    -m PEM \
    -t rsa \
    -b 4096 \
    -C "azureuser@myserver" \
    -f ssh-keys/terraform-azure.pem

# Set permissions for the private key
chmod 400 ssh-keys/terraform-azure.pem
```

- Rename the generated public key (`terraform-azure.pem.pub`) to `terraform-azure.pub`.

---

## Step 3: Create Terraform and Provider Blocks (`c1-versions.tf`)

```hcl
# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0"
    }
    random = {
      source = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

# Provider Block
provider "azurerm" {
  features {}
}

# Random String Resource
resource "random_string" "myrandom" {
  length  = 6
  upper   = false
  special = false
  number  = false
}
```

---

## Step 4: Define Azure Resources

### Resource Group (`c2-resource-group.tf`):
```hcl
resource "azurerm_resource_group" "myrg" {
  name     = "myrg-1"
  location = "East US"
}
```

### Virtual Network (`c3-virtual-network.tf`):
```hcl
resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}
```

### Subnet:
```hcl
resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
```

### Public IP:
```hcl
resource "azurerm_public_ip" "mypublicip" {
  name                = "mypublicip-1"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label   = "app1-vm-${random_string.myrandom.id}"
  tags = {
    environment = "Dev"
  }
}
```

### Network Interface:
```hcl
resource "azurerm_network_interface" "myvmnic" {
  name                = "vmnic"
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

## Step 5: Create Azure Linux VM (`c4-linux-virtual-machine.tf`)

```hcl
resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  name                  = "mylinuxvm-1"
  computer_name         = "devlinux-vm1"
  resource_group_name   = azurerm_resource_group.myrg.name
  location              = azurerm_resource_group.myrg.location
  size                  = "Standard_DS1_v2"
  admin_username        = "azureuser"
  network_interface_ids = [azurerm_network_interface.myvmnic.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }

  os_disk {
    name                 = "osdisk"
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

## Step 6: Define Custom Cloud-Init Script (`app1-cloud-init.txt`)

```bash
#cloud-config
package_upgrade: false
packages:
  - httpd
write_files:
  - owner: root:root
    path: /var/www/html/index.html
    content: |
      <h1>Welcome to StackSimplify - APP-1</h1>
  - owner: root:root
    path: /var/www/html/app1/index.html
    content: |
      <!DOCTYPE html>
      <html>
        <body style="background-color:rgb(250, 210, 210);">
          <h1>Welcome to Stack Simplify - APP-1</h1>
          <p>Terraform Demo</p>
          <p>Application Version: V1</p>
        </body>
      </html>
runcmd:
  - sudo systemctl start httpd
  - sudo systemctl enable httpd
  - sudo systemctl stop firewalld
  - sudo mkdir /var/www/html/app1
  - [sudo, curl, -H, "Metadata:true", --noproxy, "*", "http://169.254.169.254/metadata/instance?api-version=2020-09-01", -o, /var/www/html/app1/metadata.html]
```

---

## Step 7: Run Terraform Commands

### Commands:
```bash
# Initialize Terraform
terraform init

# Validate Configuration
terraform validate

# Review Plan
terraform plan

# Apply Configuration
terraform apply -auto-approve
```

---

## Step 8: Verify Resources

1. Connect to the VM:
   ```bash
   ssh -i ssh-keys/terraform-azure.pem azureuser@<PUBLIC_IP>
   ```
2. Access the application:
   - `http://<PUBLIC_IP>`
   - `http://<PUBLIC_IP>/app1`
   - `http://<PUBLIC_IP>/app1/metadata.html`

---

## Step 9: Clean-Up Resources

### Commands:
```bash
# Destroy Resources
terraform destroy -auto-approve

# Remove Terraform Files
rm -rf .terraform* terraform.tfstate*
```

---

## References
1. [Azure Resource Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)
2. [Azure Virtual Network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)
3. [Azure Linux Virtual Machine](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine)

--- 
