# Terraform Module Sources

**Description:** Learn more about Terraform Module Sources and how to use different module sources in your Terraform configuration.

---

## Step-01: Introduction

### Key Points:
- **[Terraform Module Sources](https://www.terraform.io/docs/language/modules/sources.html)** provide flexibility in where you source your modules from.
- Terraform supports several types of module sources, such as local paths, the Terraform Public Registry, GitHub, and more.

---

## Step-02: `c3-static-website.tf`

```hcl
# Call our Custom Terraform Module which we built earlier
module "azure_static_website" {

  # Terraform Local Module
  # source = "./modules/azure-static-website"

  # Terraform Public Registry
  # source = "stacksimplify/staticwebsitepb/azurerm"
  # version = "1.0.0"

  # Github Clone over HTTPS
  source = "github.com/stacksimplify/terraform-azurerm-staticwebsitepublic"

  # Github Clone over SSH (if SSH is configured with your repo)
  # source = "git@github.com:stacksimplify/terraform-azurerm-staticwebsitepublic.git"

  # Github HTTPS with specific release tag
  # source = "git::https://github.com/stacksimplify/terraform-azurerm-staticwebsitepublic.git?ref=1.0.0"

  # Resource Group
  location = "eastus"
  resource_group_name = "myrg1"

  # Storage Account
  storage_account_name = "staticwebsite"
  storage_account_tier = "Standard"
  storage_account_replication_type = "LRS"
  storage_account_kind = "StorageV2"
  static_website_index_document = "index.html"
  static_website_error_404_document = "error.html"
}
```

---

## Step-03: Execute Terraform Init and Verify Module Download Directly via GitHub

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **Verify the Module:**
   - Navigate to the `.terraform` directory:
   ```bash
   cd .terraform
   ls
   cd modules
   ls
   cd azure_static_website
   ls
   cd ../../../
   ```

3. **Clean Up:**
   - Remove Terraform cache:
   ```bash
   rm -rf .terraform*
   ```

---

## Step-04: Discuss Various Other Terraform Sources

1. **GitHub Clone Over SSH:**
   If you have configured SSH with your GitHub repository:
   ```hcl
   module "azure_static_website" {
     source = "git@github.com:stacksimplify/terraform-azurerm-staticwebsitepb.git"
     ...
     ...  # Other configurations
   }
   ```

2. **Bitbucket:**
   If the module is hosted on Bitbucket:
   ```hcl
   module "azure_static_website" {
     source = "bitbucket.org/stacksimplify/terraform-azurerm-staticwebsitepb"
     ...
     ...  # Other configurations
   }
   ```

3. **Other Options:**
   Terraform supports several other module sources. Refer to the [Terraform Module Sources documentation](https://www.terraform.io/docs/language/modules/sources.html) for more details.

---

## Step-05: Exam Question

- A question related to this section is likely to ask you to select the correct **Terraform Module Source** syntax.

