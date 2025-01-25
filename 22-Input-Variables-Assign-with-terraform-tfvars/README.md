# Terraform Input Variables Using `terraform.tfvars`

**Description:** Learn how to use `terraform.tfvars` to define and override Terraform input variable values.

---

## Step-01: Introduction

The `terraform.tfvars` file is a convenient way to assign values to input variables. Terraform automatically loads this file if it is present in the working directory, overriding any `default` values specified in the variable definitions.

---

## Step-02: Assign Input Variables in `terraform.tfvars`

### Steps:
1. Create a file named `terraform.tfvars` in your working directory.
2. Define the input variables in the file as key-value pairs.

### Example `terraform.tfvars` File:
```hcl
business_unit        = "it"
environment          = "stg"
resoure_group_name   = "rg-tfvars"
resoure_group_location = "eastus2"
virtual_network_name = "vnet-tfvars"
subnet_name          = "subnet-tfvars"
```

### Key Points:
- Variables in `terraform.tfvars` override the `default` values defined in `variables.tf`.
- The file is automatically detected and loaded by Terraform during execution.

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

3. **Format Configuration Files:**
   ```bash
   terraform fmt
   ```

4. **Plan the Configuration:**
   ```bash
   terraform plan
   ```

   **Observation:**
   - Terraform uses the values from `terraform.tfvars` for variable assignments.

5. **Apply the Configuration:**
   ```bash
   terraform apply
   ```

   **Verify Resources in Azure:**
   - Confirm the following values in Azure:
     - **Resource Group Name**: `rg-tfvars`
     - **Resource Group Location**: `eastus2`
     - **Virtual Network Name**: `vnet-tfvars`
     - **Subnet Name**: `subnet-tfvars`

---

## Step-04: Clean-Up

### Steps:

1. **Destroy Resources:**
   ```bash
   terraform destroy -auto-approve
   ```

2. **Remove Terraform Files:**
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   ```

---

## Key Benefits of Using `terraform.tfvars`

- **Simplicity:** Automatically detected and loaded, reducing the need for CLI arguments.
- **Centralized Management:** Provides a single file to manage variable values for a project.
- **Override Defaults:** Easily override `default` values specified in `variables.tf`.

---

## References

- [Terraform Input Variables Documentation](https://www.terraform.io/docs/language/values/variables.html)
