# Terraform Modules Use Public Modules

**Description:** Learn to use Terraform Public Modules to simplify infrastructure management with reusable and versioned modules from the Terraform Registry.

---

## Step-01: Introduction

### Key Points:
- Terraform supports **Root Modules**, **Child Modules**, and **Published Modules** from the Terraform Registry.
- Child modules are reusable Terraform configurations encapsulated for use within other configurations.
- **Published Modules** are publicly available in the Terraform Registry for specific cloud providers or other use cases.

### Module Basics:
- **Defining a Child Module:**
  - **Source (Mandatory):** The location from which Terraform fetches the module.
  - **Version:** It's recommended to specify the version of the module to ensure compatibility.
  - **Meta-arguments:** These include `count`, `for_each`, `providers`, `depends_on`, etc.
  - **Accessing Module Output Values:** Use `output` to reference values from a module.
  - **Tainting Resources in a Module:** Resources within a module can be tainted to trigger their destruction and re-creation.

### References:
- [Module Sources](https://www.terraform.io/docs/language/modules/sources.html)

---

## Step-02: Defining a Child Module

### Key Concepts:
1. **Module Source (Mandatory):** We'll use the Terraform Registry to define our module.
2. **Module Version (Optional):** Specifying a module version is highly recommended.

For this example, we'll remove the Virtual Network and Subnet resources and use a **Virtual Network Public Registry Module**.

### Files:
1. **`c5-virtual-network.tf`:**  
```hcl
module "vnet" {
  source              = "Azure/vnet/azurerm"
  version             = "2.5.0"
  vnet_name           = local.vnet_name
  resource_group_name = azurerm_resource_group.myrg.name
  address_space       = ["10.0.0.0/16"]
  subnet_prefixes     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  subnet_names        = ["subnet1", "subnet2", "subnet3"]
  subnet_service_endpoints = {
    subnet2 = ["Microsoft.Storage", "Microsoft.Sql"],
    subnet3 = ["Microsoft.AzureActiveDirectory"]
  }
  tags = {
    environment = "dev"
    costcenter  = "it"
  }
  depends_on = [azurerm_resource_group.myrg]
}
```

---

## Step-03: Changes to Network Interface

### File:
1. **`c5-virtual-network.tf`:**  
```hcl
resource "azurerm_network_interface" "myvmnic" {
  name                = local.nic_name
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet.vnet_subnets[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypublicip.id
  }
  tags = local.common_tags
}
```

---

## Step-04: Linux Virtual Machine Configuration

- No changes are required to the **Linux Virtual Machine** configuration.
- Since the Network Interface is the only reference in the VM resource, it will automatically adapt to the updated virtual network setup.

---

## Step-05: Define Output Values for the Virtual Network Module

### File:
1. **`c7-outputs.tf`:**  
```hcl
output "virtual_network_name" {
  description = "Virtual Network Name"
  value = module.vnet.vnet_name
}

output "virtual_network_id" {
  description = "Virtual Network ID"
  value = module.vnet.vnet_id
}

output "virtual_network_subnets" {
  description = "Virtual Network Subnets"
  value = module.vnet.vnet_subnets
}

output "virtual_network_location" {
  description = "Virtual Network Location"
  value = module.vnet.vnet_location
}

output "virtual_network_address_space" {
  description = "Virtual Network Address Space"
  value = module.vnet.vnet_address_space
}
```

---

## Step-06: Execute Terraform Commands

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **Validate Configuration:**
   ```bash
   terraform validate
   ```

3. **Format Configuration:**
   ```bash
   terraform fmt
   ```

4. **Plan:**
   ```bash
   terraform plan
   ```

5. **Apply Configuration:**
   ```bash
   terraform apply -auto-approve
   ```

### Verification:
- Confirm that all resources are created via the Azure Portal.
  - Access the VM through its public IP:  
    `http://<Public-IP-VM>/app1`
    `http://<Public-IP-VM>/app1/metadata.html`

---

## Step-07: Tainting Resources in a Module

The **taint command** can be used to taint specific resources within a module.  
**Important Note:** Modules cannot be tainted as a whole; each resource inside the module must be tainted individually.

### Steps:
1. **List Resources from State:**
   ```bash
   terraform state list
   ```

2. **Taint a Resource:**
   ```bash
   terraform taint module.vnet.azurerm_subnet.subnet[2]
   ```

3. **Plan:**
   ```bash
   terraform plan
   ```
   **Observation:** Subnet2 will be destroyed and recreated.

4. **Apply Changes:**
   ```bash
   terraform apply -auto-approve
   ```

---

## Step-08: Clean Up Resources and Local Working Directory

### Commands:
1. **Destroy Resources:**
   ```bash
   terraform destroy -auto-approve
   ```

2. **Delete Terraform Files:**
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   ```

---

## Step-09: Meta-Arguments for Modules

Meta-arguments allow for more dynamic and flexible configurations. The following concepts are applicable to modules, just as they are for resources:
1. `count`
2. `for_each`
3. `providers`
4. `depends_on`
5. `lifecycle`

### References:
- [Meta-Arguments for Modules](https://www.terraform.io/docs/language/modules/syntax.html#meta-arguments)

---

## Step-10: Discussing Module Sources

You can use **module sources** to specify where Terraform should pull a module from.  
- [Module Sources](https://www.terraform.io/docs/language/modules/sources.html)

---
