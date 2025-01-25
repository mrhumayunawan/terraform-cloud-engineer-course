# Terraform Input Variables Assign When Prompted

**Description:** Learn how to define Terraform input variables without default values to prompt users for input during `terraform plan` or `terraform apply`.

---

## Step-01: Introduction

- Terraform allows input variables to be assigned interactively when they don't have default values.
- When executing `terraform plan` or `terraform apply`, Terraform prompts the user to provide values for these variables.

---

## Step-02: Input Variables Assigned When Prompted

### Add a Variable Without a Default Value:
Update the `c2-variables.tf` file with a new variable:

```hcl
# 6. Subnet Name: Assign When Prompted using CLI
variable "subnet_name" {
  description = "Virtual Network Subnet Name"
  type        = string
}
```

### Explanation:
- **No Default Value:** Terraform will prompt for `subnet_name` during execution.
- This is useful when the value is expected to change frequently or should not be hardcoded.

---

## Step-03: Update `c4-virtual-network.tf` to Use the Variable

Add a subnet resource to the Virtual Network, utilizing the new variable:

```hcl
# Create Subnet
resource "azurerm_subnet" "mysubnet" {
  name                 = "${azurerm_virtual_network.myvnet.name}-${var.subnet_name}"
  resource_group_name  = azurerm_resource_group.myrg.name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = ["10.0.2.0/24"]
}
```

### Example:
- If `azurerm_virtual_network.myvnet.name` is `hr-dev-myvnet` and `subnet_name` is `subnet1`, the subnet name will be `hr-dev-myvnet-subnet1`.

---

## Step-04: Execute Terraform Commands

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

4. **Run Terraform Plan:**
   ```bash
   terraform plan
   ```

   **Observation:**
   - Terraform will prompt for the value of `subnet_name`:
     ```text
     var.subnet_name
       Enter a value:
     ```
   - Enter a value, for example: `subnet1`.

5. **Apply Configuration:**
   ```bash
   terraform apply
   ```

   **Observation:**
   - Terraform will prompt for the `subnet_name` again unless provided via CLI or environment variable.
   - Example of providing the variable directly:
     ```bash
     terraform apply -var="subnet_name=subnet1"
     ```

---

## Step-05: Verify Resources in Azure

- Check the **Resource Group Name** in Azure.
- Check the **Virtual Network Name** in Azure.
- Check the **Subnet Name** in Azure, which will include the value you provided (e.g., `hr-dev-myvnet-subnet1`).

---

## Step-06: Clean-Up

### Steps:
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

## Summary

- Input variables without default values ensure dynamic configurations by prompting users for input during runtime.
- Terraform supports providing variable values interactively, via CLI flags, or environment variables for flexibility.

---

## References

- [Terraform Input Variables Documentation](https://www.terraform.io/docs/language/values/variables.html)

