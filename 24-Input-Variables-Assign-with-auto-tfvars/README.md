# Terraform Input Variables Using `.auto.tfvars`

**Description:** Learn how to use `.auto.tfvars` files to automatically load Terraform input variables during `terraform plan` or `terraform apply`.

---

## Step-01: Introduction

- Terraform supports providing input variables through files with the `.auto.tfvars` extension.
- Files with this extension are automatically loaded by Terraform during execution, eliminating the need to explicitly specify them with the `-var-file` argument.

---

## Step-02: Automatically Load Input Variables

### Key Features:
- Any file with the `.auto.tfvars` extension is automatically detected and loaded by Terraform.
- You can create multiple `.auto.tfvars` files, and Terraform will automatically merge their contents during execution.

### Example Workflow

1. **Create `.auto.tfvars` File:**
   - Create a file named `<any-name>.auto.tfvars`.
   - Define variables within this file.

   **Example:**
   ```hcl
   business_unit          = "finance"
   resoure_group_name     = "rg-autotfvars"
   virtual_network_name   = "vnet-autotfvars"
   subnet_name            = "subnet-autotfvars"
   environment            = "production"
   resoure_group_location = "centralus"
   ```

2. **Run Terraform Commands:**

   - **Initialize Terraform:**
     ```bash
     terraform init
     ```

   - **Validate Configuration Files:**
     ```bash
     terraform validate
     ```

   - **Format Configuration Files:**
     ```bash
     terraform fmt
     ```

   - **Review Terraform Plan (Auto Loads Variables):**
     ```bash
     terraform plan
     ```

   - **Apply Configuration:**
     ```bash
     terraform apply
     ```

---

## Benefits of `.auto.tfvars`

- **Ease of Use:** No need to specify variable files with the `-var-file` argument.
- **Automatic Loading:** All `.auto.tfvars` files in the directory are automatically loaded.
- **Organized Configuration:** Facilitates easier management of variables in larger projects.

---

## References

- [Terraform Input Variables Documentation](https://www.terraform.io/docs/language/values/variables.html)
