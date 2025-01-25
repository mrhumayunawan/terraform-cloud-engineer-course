# Terraform Sensitive Input Variables

**Description:** Learn how to manage sensitive input variables in Terraform configurations, including securing values, handling sensitive variables, and leveraging best practices.

---

## Step-01: Introduction

- Explore variable types:
  1. Boolean
  2. Number
  3. Sensitive
- Protect sensitive input variables and avoid exposing sensitive information.

---

## Step-02: Protecting Sensitive Input Variables

### Key Practices:
- Use the `sensitive` attribute for variables to redact their values in logs and output.
- Environment variables can be used to set sensitive values but might expose them in history or environments:
  ```bash
  export TF_VAR_db_username=admin TF_VAR_db_password=securepassword
  ```
- Sensitive variables are treated like other variables in configurations but are **redacted** in logs and output.
- **Important Notes:**
  1. Never check in sensitive files like `secrets.tfvars` to version control.
  2. Sensitive values appear in `terraform.tfstate`, so secure your state file.

---

## Step-03: Terraform Configuration (`c1-versions.tf`)

- Use the following configuration for Terraform provider versions:
  ```hcl
  terraform {
    required_version = ">= 0.15"
    required_providers {
      azurerm = {
        source  = "hashicorp/azurerm"
        version = ">= 2.0"
      }
    }
  }

  provider "azurerm" {
    features {}
  }
  ```

---

## Step-04: Sensitive Variables (`c2-variables.tf`)

Define database-related sensitive and non-sensitive variables:
```hcl
# Azure MySQL DB Name
variable "db_name" {
  description = "Azure MySQL Database Name"
  type        = string
}

# Azure MySQL DB Username (Sensitive)
variable "db_username" {
  description = "Azure MySQL Database Administrator Username"
  type        = string
  sensitive   = true
}

# Azure MySQL DB Password (Sensitive)
variable "db_password" {
  description = "Azure MySQL Database Administrator Password"
  type        = string
  sensitive   = true
}

# Azure MySQL DB Storage in MB
variable "db_storage_mb" {
  description = "Azure MySQL Database Storage in MB"
  type        = number
}

# Azure MySQL DB Auto Grow Feature
variable "db_auto_grow_enabled" {
  description = "Enable or Disable Auto Grow Feature"
  type        = bool
}
```

---

## Step-05: MySQL Server Resource (`c4-azure-mysql-database.tf`)

Create an Azure MySQL database server:
```hcl
resource "azurerm_mysql_server" "mysqlserver" {
  name                = "${var.business_unit}-${var.environment}-${var.db_name}"
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  administrator_login          = var.db_username
  administrator_login_password = var.db_password

  sku_name   = "B_Gen5_2"
  storage_mb = var.db_storage_mb
  version    = "8.0"

  auto_grow_enabled             = var.db_auto_grow_enabled
  backup_retention_days         = 7
  geo_redundant_backup_enabled  = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled = true
  ssl_enforcement_enabled       = false

  tags = var.common_tags
}
```

---

## Step-06: MySQL Database Schema (`c4-azure-mysql-database.tf`)

Add a schema to the Azure MySQL database server:
```hcl
resource "azurerm_mysql_database" "webappdb1" {
  name                = "webappdb1"
  resource_group_name = azurerm_resource_group.myrg.name
  server_name         = azurerm_mysql_server.mysqlserver.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}
```

---

## Step-07: Variable File (`terraform.tfvars`)

Define general and database variables in `terraform.tfvars`:
```hcl
# General Variables
business_unit = "it"
environment = "dev"

# Resource Group Variables
resoure_group_name = "rg"
resoure_group_location = "eastus"

# DB Variables
db_name = "mydb101"
db_storage_mb = 5120
db_auto_grow_enabled = true
```

---

## Step-08: Secrets File (`secrets.tfvars`)

Define sensitive values in `secrets.tfvars`:
```hcl
# Sensitive Variables
db_username = "mydbadmin"
db_password = "H@Sh1CoR3!"
```

---

## Step-09: Execute Terraform Commands

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

4. **Plan and Apply:**
   ```bash
   terraform plan -var-file="secrets.tfvars"
   terraform apply -var-file="secrets.tfvars"
   ```

### Observations:
- Sensitive values (`db_username`, `db_password`) are redacted in the plan output:
  ```plaintext
  + administrator_login          = (sensitive)
  + administrator_login_password = (sensitive value)
  ```

5. **Verify State Files:**
   ```bash
   grep administrator_login terraform.tfstate
   grep administrator_login_password terraform.tfstate
   ```
   - Sensitive values are stored in plaintext in `terraform.tfstate`.

---

## Step-10: Verify and Connect to MySQL DB

1. **Azure Management Console:**
   - Add your public IP to the MySQL server’s firewall rules.
   - Use a MySQL client to connect and verify the `webappdb1` schema:
     ```bash
     mysql -h <Azure DB Server Name> -u <Admin Username> -p<Password>
     ```

2. **Azure Shell:**
   - Add Azure Shell’s public IP to firewall rules.
   - Connect using the same MySQL client commands.

---

## Step-11: Clean-Up

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

## Step-12: Variable Definition Precedence

- Learn about [Terraform Variable Definition Precedence](https://www.terraform.io/docs/language/values/variables.html#variable-definition-precedence).

---

## References

- [Terraform Input Variables Documentation](https://www.terraform.io/docs/language/values/variables.html)
