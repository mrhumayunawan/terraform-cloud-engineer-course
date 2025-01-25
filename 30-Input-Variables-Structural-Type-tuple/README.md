# Terraform Input Variables with Structural Type `tuple`

**Description:** Learn how to use Terraform input variables with the structural type `tuple` for organizing multiple values of different types in a sequence.

---

## Step-01: Introduction

- Structural types in Terraform allow grouping values of different types into a single variable.
- **`object`:** A collection of values, each with a named key and type.
- **`tuple`:** A sequence of values, each with its own type, identified by their order.

### Example:
#### Object
```hcl
# Object Example
variable "os_configs" {
  type = object({
    location       = string
    size           = string
    instance_count = number
  })
}
```

#### Tuple
```hcl
# Tuple Example
variable "tuple_sample" {
  type = tuple([string, number, bool])
}
```

---

## Step-02: Define Threat Detection Policy Variable

Define the `threat_detection_policy` block using the `tuple` type in `c2-variables.tf`.

```hcl
# Azure MySQL DB Threat Detection Policy (Variable Type: tuple)
variable "tdpolicy" {
  description = "Azure MySQL DB Threat Detection Policy"
  type = tuple([bool, number, bool, list(string)])
}
```

---

## Step-03: Update MySQL Server Tier

Threat detection is not supported in the **Basic Tier**, so update the `sku_name` to **General Purpose Tier**.

#### Update in `c4-azure-mysql-database.tf`:
```hcl
# Before
sku_name = "B_Gen5_2" # Basic Tier

# After
sku_name = "GP_Gen5_2" # General Purpose Tier
```

---

## Step-04: Update `terraform.tfvars`

Add values for the `tdpolicy` tuple in `terraform.tfvars`.

```hcl
# DB Variables
db_name = "mydb101"
db_storage_mb = 5120
db_auto_grow_enabled = true

# Threat Detection Policy
tdpolicy = [true, 10, true, ["dkalyanreddy@gmail.com", "stacksimplify@gmail.com"]]
```

---

## Step-05: Add Threat Detection Policy Block

#### With Hardcoded Values:
```hcl
threat_detection_policy {
  enabled = true
  retention_days = 10
  email_account_admins = true
  email_addresses = ["dkalyanreddy@gmail.com", "stacksimplify@gmail.com"]
}
```

#### With `tuple` Type Variable:
```hcl
threat_detection_policy {
  enabled = var.tdpolicy[0]
  retention_days = var.tdpolicy[1]
  email_account_admins = var.tdpolicy[2]
  email_addresses = var.tdpolicy[3]
}
```

---

## Step-06: Execute Terraform Commands

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

4. **Review the Plan:**
   ```bash
   terraform plan -var-file="secrets.tfvars"
   ```

### Observations:
- Verify that the values for `tdpolicy` are correctly replaced from `terraform.tfvars`.

5. **Optional: Apply Configuration**
   ```bash
   terraform apply -var-file="secrets.tfvars"
   ```

---

## Step-07: Verify Azure MySQL DB Threat Detection Policy Settings

1. Navigate to **Azure Portal**.
2. Go to:
   - **Azure MySQL Database** -> **it-dev-mydb101** -> **Security** -> **Azure Defender for MySQL**.
3. Confirm that the threat detection policy settings match the applied configuration.

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
- [Terraform Structural Types Documentation](https://www.terraform.io/docs/language/expressions/type-constraints.html#structural-types)
