# Terraform Input Variables Using `-var-file` Argument

**Description:** Learn how to use Terraform input variables with the `-var-file` CLI argument, leveraging `.tfvars` files for organized and environment-specific variable management.

---

## Step-01: Introduction

- Terraform supports passing input variables via `<any-name>.tfvars` files using the `-var-file` argument.
- This method is helpful for managing variables across different environments (e.g., development, QA, production) without altering configuration files.

---

## Step-02: Using `-var-file` for Input Variables

### Overview
- Explicitly use the `-var-file` argument when providing `.tfvars` files with names other than the default `terraform.tfvars`.
- Common variable definitions reside in `terraform.tfvars`, while environment-specific variables are stored in files like `dev.tfvars` and `qa.tfvars`.

### Files Used in This Example

1. **terraform.tfvars:** Contains shared variables across environments.
2. **dev.tfvars:** Defines `environment` and `resource_group_location` for the development environment.
3. **qa.tfvars:** Defines `environment` and `resource_group_location` for the QA environment.

### File Contents

#### `terraform.tfvars`
```hcl
business_unit          = "it"
resoure_group_name     = "rg-tfvars"
virtual_network_name   = "vnet-tfvars"
subnet_name            = "subnet-tfvars"
```

#### `dev.tfvars`
```hcl
environment            = "dev"
resoure_group_location = "eastus2"
```

#### `qa.tfvars`
```hcl
environment            = "qa"
resoure_group_location = "eastus"
```

---

## Step-03: Execute Terraform Commands

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

4. **Review Terraform Plan:**
   - For Development Environment:
     ```bash
     terraform plan -var-file="dev.tfvars"
     ```
   - For QA Environment:
     ```bash
     terraform plan -var-file="qa.tfvars"
     ```

5. **Apply Configuration:**
   - Apply for Development Environment:
     ```bash
     terraform apply -var-file="dev.tfvars"
     ```
   - Apply for QA Environment:
     ```bash
     terraform apply -var-file="qa.tfvars"
     ```
   **Important Observation:**
   - Applying QA environment directly after Development from the same directory may result in resource conflicts. 
   - This occurs because resource names are identical across environments. Using Terraform workspaces (covered later in the course) can address this issue by creating isolated environments.

---

## Step-04: Clean-Up

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

## Key Points

- Use `-var-file` to provide environment-specific variable files.
- Avoid applying configurations for different environments from the same working directory unless workspaces are used.
- Organizing variables into `.tfvars` files enhances modularity and simplifies management across multiple environments.

---

## References

- [Terraform Input Variables Documentation](https://www.terraform.io/docs/language/values/variables.html)
