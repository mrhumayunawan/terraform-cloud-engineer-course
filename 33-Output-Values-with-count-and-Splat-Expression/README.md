# Terraform Output Values with Splat Expression

**Description:** Learn how to use splat expressions in Terraform to simplify output definitions, especially when using the `count` meta-argument.

---

## Step-01: Introduction

- **Splat Expression:** A concise way to iterate over elements of a list and access specific attributes.  
  - **Syntax:** `[element[*].attribute]`
- **Use Case:** When the `count` meta-argument is used in resources, splat expressions simplify accessing attributes of multiple resource instances.

### Example:
#### Without Splat Expression:
```hcl
[for o in var.list : o.id]
```

#### With Splat Expression:
```hcl
var.list[*].id
```

---

## Step-02: Update Virtual Network Resource (`c4-virtual-network.tf`)

Add the `count` meta-argument to create multiple virtual networks:
```hcl
# Create Virtual Network
resource "azurerm_virtual_network" "myvnet" {
  count               = 4
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network_name}-${count.index}"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name
}
```

---

## Step-03: Execute Terraform Commands

### Steps:
1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **Validate Configuration:**
   ```bash
   terraform validate
   ```

### Expected Error:
```plaintext
│ Error: Missing resource instance key
│ 
│   on c5-outputs.tf line 16, in output "virtual_network_name":
│   16:   value = azurerm_virtual_network.myvnet.name
│ 
│ Because azurerm_virtual_network.myvnet has "count" set, its attributes must be
│ accessed on specific instances.
│ 
│ For example, to correlate with indices of a referring resource, use:
│     azurerm_virtual_network.myvnet[count.index]
```

---

## Step-04: Update Output Values with Splat Expression (`c5-outputs.tf`)

Update the output for `virtual_network_name` to use a splat expression:
```hcl
# Virtual Network Outputs
output "virtual_network_name" {
  description = "Virtual Network Names"
  value       = azurerm_virtual_network.myvnet[*].name
}
```

---

## Step-05: Re-Execute Terraform Commands

### Steps:
1. **Validate Configuration:**
   ```bash
   terraform validate
   ```
   **Observation:** Validation should pass.

2. **Format Files:**
   ```bash
   terraform fmt
   ```

3. **Review Plan:**
   ```bash
   terraform plan
   ```

### Expected Output:
```plaintext
Changes to Outputs:
  + resource_group_id    = (known after apply)
  + resource_group_name  = "it-dev-rg"
  + virtual_network_name = [
      + "it-dev-vnet-0",
      + "it-dev-vnet-1",
      + "it-dev-vnet-2",
      + "it-dev-vnet-3",
    ]
```

4. **Apply Configuration (Optional):**
   ```bash
   terraform apply -auto-approve
   ```

**Observation:** All virtual network names should appear as a list in the output.

---

## Step-06: Destroy Resources

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
- [Terraform Splat Expression Documentation](https://www.terraform.io/docs/language/expressions/splat.html)
