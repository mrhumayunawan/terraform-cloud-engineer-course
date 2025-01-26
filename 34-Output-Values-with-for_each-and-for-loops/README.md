# Terraform Output Values with `for_each` and `for` Loop

**Description:** Learn how to define output values when using the `for_each` meta-argument and utilize `for` loops for dynamic resource attributes.

---

## Step-01: Introduction

- When using the `for_each` meta-argument, resources are represented as a **map of objects**.
- Splat expressions (e.g., `[*]`) **do not work** with resources defined using `for_each`.
- Use a **`for` loop** to extract and process attributes from resources in the outputs.

### Key Concepts:
- **`for` Expression:** Dynamically generate lists or maps from existing resources or variables.
- **`keys()` and `values()` Functions:** Extract keys or values from a map.

---

## Step-02: Define Environment Variable as `set` (`c2-variables.tf`)

Update the `environment` variable:
```hcl
variable "environment" {
  description = "Environment Name"
  type        = set(string)
  default     = ["dev1", "qa1", "staging1", "prod1"]
}
```

---

## Step-03: Update `terraform.tfvars`

Specify environments in `terraform.tfvars`:
```hcl
business_unit         = "it"
environment           = ["dev2", "qa2", "staging2", "prod2"]
resoure_group_name    = "rg"
virtual_network_name  = "vnet"
```

---

## Step-04: Convert Virtual Network Resource to Use `for_each` (`c4-virtual-network.tf`)

Modify the virtual network resource to loop over environments:
```hcl
resource "azurerm_virtual_network" "myvnet" {
  for_each            = var.environment
  name                = "${var.business_unit}-${each.key}-${var.virtual_network_name}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}
```

---

## Step-05: Test Output with Splat Expression (`c5-outputs.tf`)

Attempt using a splat expression for the virtual network name:
```hcl
output "virtual_network_name" {
  description = "Virtual Network Name"
  value       = azurerm_virtual_network.myvnet[*].name
}
```

### Expected Error:
```plaintext
│ Error: Unsupported attribute
│ 
│ This object does not have an attribute named "name".
```

---

## Step-06: Define Output Values Using `for` Loop

Update the outputs to use `for` loops:

### Outputs with List Output
```hcl
# For Loop with One Input, List Output (Virtual Network Names)
output "virtual_network_name_list_one_input" {
  description = "Virtual Network Names"
  value       = [for vnet in azurerm_virtual_network.myvnet : vnet.name]
}

# For Loop with Two Inputs, List Output (Iterator Name)
output "virtual_network_name_list_two_inputs" {
  description = "Virtual Network Names (Environment)"
  value       = [for env, vnet in azurerm_virtual_network.myvnet : env]
}
```

### Outputs with Map Output
```hcl
# For Loop with One Input, Map Output (VNET ID to Name)
output "virtual_network_name_map_one_input" {
  description = "Virtual Network Name Map (ID to Name)"
  value       = {for vnet in azurerm_virtual_network.myvnet : vnet.id => vnet.name}
}

# For Loop with Two Inputs, Map Output (Environment to Name)
output "virtual_network_name_map_two_inputs" {
  description = "Virtual Network Name Map (Environment to Name)"
  value       = {for env, vnet in azurerm_virtual_network.myvnet : env => vnet.name}
}
```

### Outputs Using `keys()` and `values()`
```hcl
# Extract Keys (Environment)
output "virtual_network_name_keys_function" {
  description = "Keys from Virtual Network Map"
  value       = keys({for vnet in azurerm_virtual_network.myvnet : vnet.id => vnet.name})
}

# Extract Values (Virtual Network Names)
output "virtual_network_name_values_function" {
  description = "Values from Virtual Network Map"
  value       = values({for vnet in azurerm_virtual_network.myvnet : vnet.id => vnet.name})
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

3. **Review the Plan:**
   ```bash
   terraform plan
   ```

### Expected Output:
```plaintext
Changes to Outputs:
  + resource_group_id    = (known after apply)
  + resource_group_name  = "it-dev2-rg"
  + virtual_network_name_list_one_input = [
      "it-dev2-vnet",
      "it-qa2-vnet",
      "it-staging2-vnet",
      "it-prod2-vnet",
    ]
  + virtual_network_name_list_two_inputs = [
      "dev2",
      "qa2",
      "staging2",
      "prod2",
    ]
  + virtual_network_name_map_one_input = {
      "vnet-id-1" = "it-dev2-vnet",
      ...
    }
```

4. **Apply the Configuration:**
   ```bash
   terraform apply -auto-approve
   ```

---

## Step-08: Destroy Resources

1. **Destroy Resources:**
   ```bash
   terraform destroy -auto-approve
   ```

2. **Clean Up Files:**
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   ```

---

## References

- [Terraform Output Values Documentation](https://www.terraform.io/docs/language/values/outputs.html)
- [Terraform For Expressions](https://www.terraform.io/docs/language/expressions/for.html)
- [Terraform Keys Function](https://www.terraform.io/docs/language/functions/keys.html)
- [Terraform Values Function](https://www.terraform.io/docs/language/functions/values.html)
