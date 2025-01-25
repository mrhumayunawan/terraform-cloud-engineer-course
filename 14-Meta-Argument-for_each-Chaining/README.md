# Terraform Resource Meta-Argument `for_each` Chaining

**Description:** Learn how to use Terraform's `for_each` meta-argument chaining, which enables one resource to directly use another resource with a `for_each` argument in a one-to-one relationship.

---

## Step-01: Introduction

- Understand how to implement the `for_each` meta-argument with chaining.
- Terraform allows resources defined with `for_each` to appear as **maps of objects** or **sets of strings**. This enables direct use of one resource as the `for_each` argument of another resource.
- Example:
  - Use `azurerm_network_interface.myvmnic` directly in `azurerm_linux_virtual_machine.mylinuxvm` to simplify configurations.
- **Scenario:** Provision 2 VMs (`vm1`, `vm2`) using `for_each` chaining for their associated public IPs and network interfaces.

---

## Step-02: Review Terraform Manifests

Copy the Terraform manifests from the previous `count` example and modify them to use `for_each` with chaining.

### Files to Modify:
1. `c1-versions.tf`
2. `c2-resource-group.tf`
3. `c3-virtual-machine.tf`: Modify Public IP and Network Interface resources to use `for_each`.
4. `c4-linux-virtual-machine.tf`: Implement `for_each` chaining using the network interface resource.

---

## Step-03: `c3-virtual-machine.tf` - Azure Public IP Resource

```hcl
# Create Azure Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  for_each = toset(["vm1", "vm2"]) # Create one public IP for each VM
  name                = "mypublicip-${each.key}"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label   = "app1-${each.key}-${random_string.myrandom.id}"
}
```

---

## Step-04: `c3-virtual-machine.tf` - Azure Network Interface Resource

```hcl
# Create Network Interface
resource "azurerm_network_interface" "myvmnic" {
  for_each = toset(["vm1", "vm2"]) # Create one network interface for each VM
  name                = "vmnic-${each.key}"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypublicip[each.key].id
  }
}
```

---

## Step-05: `c4-linux-virtual-machine.tf` - Azure Linux VM Resource

```hcl
# Resource: Azure Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  for_each = azurerm_network_interface.myvmnic # Use for_each chaining from network interface resource

  depends_on = [azurerm_network_interface.myvmnic] # Ensure NIC exists before VM creation
  name                = "mylinuxvm-${each.key}"
  computer_name       = "devlinux-${each.key}" # Hostname of the VM
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
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

### Key Explanation:
- **`for_each` Chaining:** `azurerm_linux_virtual_machine` directly uses `azurerm_network_interface.myvmnic` as its `for_each` argument.
- **Dependency Management:** The `depends_on` argument ensures that the VM is created only after its associated network interface exists.

---

## Step-06: Observe the `for_each` Chaining

- In the `azurerm_linux_virtual_machine` resource, the `for_each` argument uses the network interface resource:
  ```hcl
  for_each = azurerm_network_interface.myvmnic
  ```
- This chaining establishes a direct one-to-one relationship between the network interfaces and the VMs.

---

## Step-07: Execute Terraform Commands

### **1. Initialize Terraform**
```bash
terraform init
```

### **2. Validate Configuration**
```bash
terraform validate
```

### **3. Format Configuration Files**
```bash
terraform fmt
```

### **4. Plan the Configuration**
```bash
terraform plan
```

**Observations:**
1. Terraform will generate:
   - 2 Public IP resources.
   - 2 Network Interface resources.
   - 2 Linux VM resources.
2. Resource names in the plan:
   - `azurerm_public_ip.mypublicip["vm1"]`
   - `azurerm_network_interface.myvmnic["vm1"]`
   - `azurerm_linux_virtual_machine.mylinuxvm["vm1"]`.

### **5. Apply the Configuration**
```bash
terraform apply
```

**Verification:**
1. Confirm the following resources in Azure:
   - Resource Groups
   - Virtual Network
   - Subnet
   - 2 Public IPs
   - 2 Network Interfaces
   - 2 Linux Virtual Machines
2. Access the application:
   ```bash
   http://<PUBLIC_IP-1>
   http://<PUBLIC_IP-2>
   ```

---

## Step-08: Destroy Terraform Resources

### **Destroy All Resources**
```bash
terraform destroy
```

### **Clean-Up Files**
```bash
rm -rf .terraform*
rm -rf terraform.tfstate*
```

---

## Summary

- The `for_each` meta-argument chaining simplifies resource dependencies.
- Directly using one resource (e.g., `azurerm_network_interface`) as the `for_each` argument in another (e.g., `azurerm_linux_virtual_machine`) reduces complexity.
- This approach is highly scalable and ensures consistency in resource provisioning.
