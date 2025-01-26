# Terraform Override Files

**Description:** Learn how to use **Terraform Override Files** to modify or override specific settings and configurations in Terraform code without modifying the main configuration files.

---

## Step-01: Introduction

### Key Points:
- **[Terraform Override Files](https://www.terraform.io/docs/language/files/override.html)** allow you to modify the behavior of your Terraform configuration without changing the original configuration files.
- You can use override files to adjust resource definitions, variables, or provider settings specifically for certain environments or conditions.
- Common override file formats:
  1. **`override.tf`**
  2. **`somefilename_override.tf`**

---

## Step-02: Review Terraform Configs in `terraform-manifests-v1`

In this example, we have a set of Terraform configuration files:

1. `c1-versions.tf`
2. `c2-variables.tf`
3. `c3-resource-group.tf`
4. `c4-virtual-network.tf`
5. `terraform.tfvars`

---

## Step-03: `terraform-manifests-v1 - override.tf`

In the override file, you can redefine resources or their arguments. Here, we define the same **Azure Resource Group** resource but with a different `location`.

```hcl
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  #name = var.resource_group_name
  name     = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  location = "westus"
}
```

---

## Step-04: `terraform-manifests-v1 - Execute Terraform Commands`

Now, let's run Terraform commands and observe the results.

```bash
# Change Directory
cd terraform-manifests-v1/

# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Observation
# 1. Review the location for all resources.
# 2. Location of all resources should be "westus" because it has picked the information from "override.tf"

# Clean-Up
rm -rf .terraform*
```

---

## Step-05: `terraform-manifests-v2 - c3-resource-group_override.tf`

In the second version (`terraform-manifests-v2`), the `c3-resource-group_override.tf` file is used to specify the location again, overriding the main configuration.

```hcl
# Resource-1: Azure Resource Group
resource "azurerm_resource_group" "myrg" {
  #name = var.resource_group_name
  name     = "${var.business_unit}-${var.environment}-${var.resoure_group_name}"
  location = "westus"
}
```

---

## Step-06: `terraform-manifests-v2 - Execute Terraform Commands`

Execute the same Terraform commands in the second version and verify the result.

```bash
# Change Directory
cd terraform-manifests-v2/

# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Observation
# 1. Review the location for all resources.
# 2. Location of all resources should be "westus" because it has picked the information from "c3-resource-group_override.tf"

# Clean-Up
rm -rf .terraform*
```

---

## Step-07: Discuss About `.gitignore` Terraform - Default Behavior

By default, Terraform uses a `.gitignore` file that excludes override files. These files are typically used for local overrides and are not meant to be checked into version control.

Here’s the default behavior in `.gitignore`:

```txt
# Ignore override files as they are usually used to override resources locally and so
# are not checked in
#override.tf
#override.tf.json
#*_override.tf
#*_override.tf.json
```

If you need to check in your override files to version control, you’ll need to uncomment these lines in `.gitignore` to allow them to be tracked.

---
