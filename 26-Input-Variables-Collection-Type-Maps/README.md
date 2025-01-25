# Terraform Input Variables with Collection Type `maps`

**Description:** Learn how to use Terraform input variables of type `map` for structured key-value data and utilize the `lookup` function for dynamic resource configurations.

---

## Step-01: Introduction

- Implement complex type constructors like `maps` for managing collections of related values.
- Use the `lookup` function to extract specific values from a map with optional default values.

---

## Step-02: Defining `maps` in Variables

### Key Features:
- **Type Constraints:** The `map` type organizes values as key-value pairs.
- Common use cases include settings for resource configurations or tags.

### Example Variables

#### `public_ip_sku` and `common_tags`

```hcl
# Azure Public IP Address SKU
variable "public_ip_sku" {
  description = "Azure Public IP Address SKU"
  type        = map(string)
  default     = {
    "eastus"  = "Basic"
    "eastus2" = "Standard"
  }
}

# Common Tags for Azure Resources
variable "common_tags" {
  description = "Common Tags for Azure Resources"
  type        = map(string)
  default     = {
    "CLITool" = "Terraform"
    "Tag1"    = "Azure"
  }
}
```

---

## Step-03: Updating Terraform Configurations

### Update Public IP Resource

#### `c4-virtual-network.tf`
```hcl
# Create Public IP Address
resource "azurerm_public_ip" "mypublicip" {
  name                = "mypublicip-1"
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label   = "app1-vm-${random_string.myrandom.id}"
  sku                 = lookup(var.public_ip_sku, var.resoure_group_location)  # Dynamic SKU selection
  tags                = var.common_tags
}
```

### Add `common_tags` to Other Resources

Update the `tags` attribute for the following resources:
- **azurerm_resource_group**
- **azurerm_virtual_network**
- **azurerm_public_ip**
- **azurerm_network_interface**

```hcl
tags = var.common_tags
```

---

## Step-04: Using the `lookup()` Function

### Understanding `lookup`:

The `lookup` function retrieves a value from a map by key, with an optional default value.

#### Example:
```hcl
# Basic Syntax
lookup({a="ay", b="bee"}, "a", "default")  # Output: "ay"
lookup({a="ay", b="bee"}, "c", "default")  # Output: "default"

# Example with `public_ip_sku` map
lookup({"eastus"="Basic", "eastus2"="Standard"}, "eastus", "Basic")  # Output: "Basic"
```

---

## Step-05: Execute Terraform Commands

### Steps:

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
1. Verify the Public IP SKU is set to `"Standard"` for the specified location.
2. Check resource tags in the Azure Management Console for consistency.

---

## Step-06: Reference Specific Map Values

### Updating Public IP SKU Reference

1. **Reference a Specific Map Value:**
   ```hcl
   sku = var.public_ip_sku["eastus"]
   ```

2. **Comment Out Dynamic Lookup:**
   ```hcl
   # sku = lookup(var.public_ip_sku, var.resoure_group_location)
   ```

3. **Reapply Configuration:**
   ```bash
   terraform plan
   terraform apply -auto-approve
   ```

### Observations:
- The Public IP resource SKU is updated to `"Basic"` for the `eastus` region.

---

## Step-07: Clean-Up

1. **Destroy Resources:**
   ```bash
   terraform destroy -auto-approve
   ```

2. **Remove Terraform State Files:**
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   ```

3. **Rollback to Dynamic SKU Configuration:**
   ```hcl
   sku = lookup(var.public_ip_sku, var.resoure_group_location)
   ```

---

## Step-08: Important Notes on Maps

- When a key in a map starts with a number, use the colon syntax `:` instead of `=` to avoid parsing errors.

#### Example:
```hcl
variable "my_env_names" {
  type = map(string)
  default = {
    "1-development": "dev-apps"
    "2-staging":     "staging-apps"
    "3-production":  "prod-apps"
  }
}
```

---

## References

- [Terraform Input Variables Documentation](https://www.terraform.io/docs/language/values/variables.html)
- [Terraform Lookup Function Documentation](https://www.terraform.io/docs/language/functions/lookup.html)
