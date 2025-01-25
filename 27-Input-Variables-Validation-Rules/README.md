# Terraform Input Variables with Validation Rules

**Description:** Learn how to implement validation rules for Terraform input variables using built-in functions like `length()`, `substr()`, `contains()`, `lower()`, `regex()`, and `can()`.

---

## Step-01: Introduction

- Understand key Terraform functions and how to use them for variable validation.
- Implement custom validation rules to enforce input constraints.

---

## Step-02: Learning Terraform `length()` Function

### Overview:
The `length()` function returns the number of elements in a string, list, or map.

#### Usage:

1. **Open Terraform Console:**
   ```bash
   terraform console
   ```

2. **Test `length()` Function:**
   ```hcl
   # String
   length("hi")
   length("hello")

   # List
   length(["a", "b", "c"])

   # Map
   length({"key" = "value"})
   length({"key1" = "value1", "key2" = "value2"})
   ```

---

## Step-03: Learning Terraform `substr()` Function

### Overview:
The `substr()` function extracts a substring from a given string.

#### Usage:

1. **Open Terraform Console:**
   ```bash
   terraform console
   ```

2. **Test `substr()` Function:**
   ```hcl
   substr("stack simplify", 1, 4)
   substr("stack simplify", 0, 6)
   substr("stack simplify", 0, 10)
   ```

---

## Step-04: Learning Terraform `contains()` Function

### Overview:
The `contains()` function checks if a list contains a specific value.

#### Usage:

1. **Open Terraform Console:**
   ```bash
   terraform console
   ```

2. **Test `contains()` Function:**
   ```hcl
   contains(["a", "b", "c"], "a")
   contains(["a", "b", "c"], "d")
   contains(["eastus", "eastus2"], "westus2")
   ```

---

## Step-05: Learning Terraform `lower()` and `upper()` Functions

### Overview:
- `lower()`: Converts a string to lowercase.
- `upper()`: Converts a string to uppercase.

#### Usage:

1. **Open Terraform Console:**
   ```bash
   terraform console
   ```

2. **Test `lower()` and `upper()` Functions:**
   ```hcl
   lower("STRING")
   upper("string")
   ```

---

## Step-06: Resource Group Variable with Validation Rules

### Variable Configuration

#### `c2-variables.tf`
```hcl
# Resource Group Location
variable "resoure_group_location" {
  description = "Resource Group Location"
  type        = string
  default     = "eastus"
  validation {
    condition     = var.resoure_group_location == "eastus" || var.resoure_group_location == "eastus2"
    error_message = "We only allow resources to be created in eastus or eastus2 locations."
  }
}
```

### Steps:

1. **Run Terraform Commands:**
   ```bash
   terraform init
   terraform validate
   terraform plan
   ```

2. **Observations:**
   - For `resoure_group_location = "eastus"` or `"eastus2"`, the plan passes.
   - For any other value, the plan fails with an error message.

---

## Step-07: Using the `contains()` Function for Validation

### Updated Validation Rule

```hcl
validation {
  condition     = contains(["eastus", "eastus2"], lower(var.resoure_group_location))
  error_message = "We only allow resources to be created in eastus or eastus2 locations."
}
```

### Steps:

1. **Reapply Terraform Plan:**
   ```bash
   terraform plan
   ```

2. **Observations:**
   - For valid values, the plan passes.
   - For invalid values, the plan fails.

---

## Step-08: Learning Terraform `regex()` and `can()` Functions

### Overview:
- `regex()`: Validates a string against a regular expression.
- `can()`: Checks if an expression can be evaluated without errors.

#### Usage:

1. **Open Terraform Console:**
   ```bash
   terraform console
   ```

2. **Test `regex()` and `can()` Functions:**
   ```hcl
   regex("india$", "westindia")   # Matches "india$"
   can(regex("india$", "eastus")) # Returns false
   ```

---

## Step-09: Update Variable Validation Using `regex()` and `can()`

#### Updated `c2-variables.tf`
```hcl
# Resource Group Location
variable "resoure_group_location" {
  description = "Resource Group Location"
  type        = string
  default     = "eastus"
  validation {
    condition     = can(regex("india$", var.resoure_group_location))
    error_message = "We only allow resources to be created in westindia and southindia locations."
  }
}
```

---

## Step-10: Run Terraform Commands

1. **Validate Configuration Files:**
   ```bash
   terraform validate
   ```

2. **Review the Plan:**
   ```bash
   terraform plan
   ```

3. **Observations:**
   - For `"westindia"` or `"southindia"`, the plan passes.
   - For other values, the plan fails with a validation error.

---

## Step-11: Clean-Up

### Steps:

1. **Destroy Resources:**
   ```bash
   terraform destroy -auto-approve
   ```

2. **Reset Files:**
   ```hcl
   variable "resoure_group_location" {
     description = "Resource Group Location"
     type        = string
     default     = "eastus"
     validation {
       condition     = var.resoure_group_location == "eastus" || var.resoure_group_location == "eastus2"
       error_message = "We only allow resources to be created in eastus or eastus2 locations."
     }
   }
   ```

---

## References

- [Terraform Input Variables Documentation](https://www.terraform.io/docs/language/values/variables.html)
- [Terraform Console Documentation](https://www.terraform.io/docs/cli/commands/console.html)
- [Terraform Functions Documentation](https://www.terraform.io/docs/language/functions/index.html)
