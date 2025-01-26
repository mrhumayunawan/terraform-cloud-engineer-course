# Terraform Datasources

**Description:** Learn how to use Terraform datasources to fetch and use information about existing infrastructure resources dynamically.

---

## Step-01: Introduction

### Overview:
- Understand the concept of datasources in Terraform and how to use them in configurations.
- Datasources allow you to query existing resources and use their attributes in your Terraform configurations.

### Use Case:
Implement the following datasources:
1. [azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group)
2. [azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network)
3. [azurerm_subscription](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription)

---

## Step-02: Resource Group Datasource (`c6-datasource-resource-group.tf`)

### Configuration:
```hcl
# Datasource for Resource Group
data "azurerm_resource_group" "rgds" {
  depends_on = [ azurerm_resource_group.myrg ]
  name       = local.rg_name 
}

# Output Examples
output "ds_rg_name" {
  value = data.azurerm_resource_group.rgds.name
}

output "ds_rg_location" {
  value = data.azurerm_resource_group.rgds.location
}

output "ds_rg_id" {
  value = data.azurerm_resource_group.rgds.id
}
```

---

## Step-03: Virtual Network Datasource (`c7-datasource-virtual-network.tf`)

### Configuration:
```hcl
# Datasource for Virtual Network
data "azurerm_virtual_network" "vnetds" {
  depends_on         = [ azurerm_virtual_network.myvnet ]
  name               = local.vnet_name
  resource_group_name = local.rg_name
}

# Output Examples
output "ds_vnet_name" {
  value = data.azurerm_virtual_network.vnetds.name
}

output "ds_vnet_id" {
  value = data.azurerm_virtual_network.vnetds.id
}

output "ds_vnet_address_space" {
  value = data.azurerm_virtual_network.vnetds.address_space
}
```

---

## Step-04: Subscription Datasource (`c8-datasource-subscription.tf`)

### Configuration:
```hcl
# Datasource for Subscription
data "azurerm_subscription" "current" {}

# Output Examples
output "current_subscription_display_name" {
  value = data.azurerm_subscription.current.display_name
}

output "current_subscription_id" {
  value = data.azurerm_subscription.current.subscription_id
}

output "current_subscription_spending_limit" {
  value = data.azurerm_subscription.current.spending_limit
}
```

---

## Step-05: Execute Terraform Commands

### Commands:
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
   - **Observations:**
     1. Verify Resource Group datasource outputs.
     2. Verify Virtual Network datasource outputs.
     3. Verify Subscription datasource outputs.

5. **Apply the Plan (Optional):**
   ```bash
   terraform apply -auto-approve
   ```

---

## Step-06: Resource Group Datasource for Existing Resources (`c9-datasource-resource-group-existing.tf`)

### Steps:
1. Create a resource group named `dsdemo` in the Azure portal.
2. Use the following configuration to query its details:
```hcl
# Datasource for an Existing Resource Group
data "azurerm_resource_group" "rgds1" {
  name = "dsdemo"
}

# Output Examples
output "ds_rg_name1" {
  value = data.azurerm_resource_group.rgds1.name
}

output "ds_rg_location1" {
  value = data.azurerm_resource_group.rgds1.location
}

output "ds_rg_id1" {
  value = data.azurerm_resource_group.rgds1.id
}
```

3. **Execute Terraform Commands:**
   ```bash
   terraform plan
   ```
   - **Observation:** You should see the `dsdemo` resource group details in the outputs.

4. After verification, **comment out** the contents of `c9-datasource-resource-group-existing.tf` to reset the configuration.

---

## Step-07: Clean-Up

### Commands:
1. **Destroy Resources:**
   ```bash
   terraform destroy -auto-approve
   ```
2. **Delete Terraform State and Configuration Files:**
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   ```

---

## References

- [Terraform Datasources Documentation](https://www.terraform.io/docs/language/data-sources/index.html)

---
