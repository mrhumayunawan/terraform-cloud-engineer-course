### **1. Virtual Network**
Defines the Azure Virtual Network (VNet).

```hcl
resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"                # Name of the VNet
  address_space       = ["10.0.0.0/16"]           # CIDR block for the VNet
  location            = azurerm_resource_group.myrg.location # Location from the resource group
  resource_group_name = azurerm_resource_group.myrg.name     # Resource group where the VNet is created
}
```

---

### **2. Subnet**
Defines a subnet within the virtual network.

```hcl
resource "azurerm_subnet" "mysubnet" {
  name                 = "mysubnet-1"                   # Subnet name
  resource_group_name  = azurerm_resource_group.myrg.name # Resource group name
  virtual_network_name = azurerm_virtual_network.myvnet.name # Associated virtual network
  address_prefixes     = ["10.0.2.0/24"]                # CIDR block for the subnet
}
```

---

### **3. Public IP Address**
Creates a static public IP address for the virtual machine.

```hcl
resource "azurerm_public_ip" "mypublicip" {
  name                = "mypublicip-1"                # Name of the public IP resource
  resource_group_name = azurerm_resource_group.myrg.name # Resource group name
  location            = azurerm_resource_group.myrg.location # Location from the resource group
  allocation_method   = "Static"                      # Static IP allocation
  domain_name_label   = "app1-vm-${random_string.myrandom.id}" # Unique DNS name for public IP
  tags = {
    environment = "Dev"                               # Tag for the resource
  }
}
```

---

### **4. Network Interface**
Creates a network interface and associates it with the subnet and public IP address.

```hcl
resource "azurerm_network_interface" "myvmnic" {
  name                = "vmnic"                      # Name of the network interface
  location            = azurerm_resource_group.myrg.location # Location from the resource group
  resource_group_name = azurerm_resource_group.myrg.name # Resource group name

  ip_configuration {
    name                          = "internal"        # Name of the IP configuration
    subnet_id                     = azurerm_subnet.mysubnet.id # Subnet associated with the NIC
    private_ip_address_allocation = "Dynamic"         # Dynamically allocate private IP
    public_ip_address_id          = azurerm_public_ip.mypublicip.id # Associate the public IP
  }
}
```

---

### Key Points:
1. **Dependencies**: 
   - The `subnet` depends on the `virtual_network`.
   - The `network_interface` depends on the `subnet` and the `public_ip_address`.

2. **Dynamic References**:
   - The configuration dynamically references IDs and attributes from other resources using interpolation (e.g., `azurerm_virtual_network.myvnet.name`).

3. **Static Public IP**:
   - The static IP ensures the VM retains its public IP even after a reboot.

4. **Tags**:
   - Tags are used to organize and manage resources effectively.

---
