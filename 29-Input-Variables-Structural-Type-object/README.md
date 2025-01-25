# Terraform Input Variables with Structural Type `object`

**Description:** Learn how to use Terraform input variables with the structural type `object` to manage complex configurations such as threat detection policies for Azure MySQL Database.

---

## Step-01: Introduction

- Structural types in Terraform allow grouping multiple values of different types into a single variable.
- Using structural types requires defining a data schema for the variable.
- **`object`:** A collection of values where each value has its own specific type.

### Example:
```hcl
# Sample object()
variable "os_configs" {
  type = object({
    location       = string
    size           = string
    instance_count = number
  })
}
```

---

## Step-02: Define Threat Detection Policy Variable

### Input Variable for Threat Detection Policy

Define the `threat_detection_policy` block as an `object` type variable in `c2-variables.tf`:
```hcl
# Azure MySQL DB Threat Detection Policy (Variable Type: Object)
variable "tdpolicy" {
  description = "Azure MySQL DB Threat Detection Policy"
  type = object({
    enabled            = bool
    retention_days     = number
    email_account_admins = bool
    email_addresses    = list(string)
  })
}
```

---

## Step-03: Update MySQL Server Tier

Threat detection is not supported for the **Basic Tier**, so update the tier to **General Purpose**.

#### Update in `c4-azure-mysql-database.tf`:
```hcl
# Before
sku_name = "B_Gen5_2" # Basic Tier

# After
sku_name = "GP_Gen5_2" # General Purpose Tier
```

---

## Step-04: Update `terraform.tfvars`

Add the configuration for `tdpolicy` in `terraform.tfvars`:
```hcl
# DB Variables
db_name = "mydb101"
db_storage_mb = 5120
db_auto_grow_enabled = true

# Threat Detection Policy
tdpolicy = {
  enabled = true
  retention_days = 10
  email_account_admins = true
  email_addresses = ["dkalyanreddy@gmail.com", "stacksimplify@gmail.com"]
}
```

---

## Step-05: Add Threat Detection Policy Block

Update the MySQL Server resource in `c4-azure-mysql-database.tf` to include the threat detection policy.

#### Using Hardcoded Values:
```hcl
threat_detection_policy {
  enabled = true
  retention_days = 10
  email_account_admins = true
  email_addresses = ["dkalyanreddy@gmail.com", "stacksimplify@gmail.com"]
}
```

#### Using Structural Type `object`:
```hcl
threat_detection_policy {
  enabled              = var.tdpolicy.enabled
  retention_days       = var.tdpolicy.retention_days
  email_account_admins = var.tdpolicy.email_account_admins
  email_addresses      = var.tdpolicy.email_addresses
}
```

---

## Step-06: Execute Terraform Commands

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

4. **Plan Execution:**
   ```bash
   terraform plan -var-file="secrets.tfvars"
   ```

### Observations:
- Review the `threat_detection_policy` values in the execution plan.
- Ensure the values from `terraform.tfvars` are applied correctly.

5. **Optional: Apply Configuration**
   ```bash
   terraform apply -var-file="secrets.tfvars"
   ```

---

## Step-07: Verify Azure MySQL DB Threat Detection Policy

1. Navigate to **Azure Portal**.
2. Go to:
   - **Azure MySQL Database** -> **`it-dev-mydb101`** -> **Security** -> **Azure Defender for MySQL**.
3. Verify the settings applied for threat detection.

---

## Step-08: Clean-Up

### Steps:

1. **Destroy Resources:**
   ```bash
   terraform destroy -var-file="secrets.tfvars"
   ```

2. **Remove Files:**
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   ```

---

## References

- [Terraform Input Variables Documentation](https://www.terraform.io/docs/language/values/variables.html)
- [Terraform Structural Types](https://www.terraform.io/docs/language/expressions/type-constraints.html#structural-types)
