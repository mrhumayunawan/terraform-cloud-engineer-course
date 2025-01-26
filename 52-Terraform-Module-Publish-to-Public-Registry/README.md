# Terraform Module Publish to Terraform Public Registry

**Description:** Learn how to publish a Terraform module to the Terraform Public Registry and version it for public use.

---

## Step-01: Introduction

### Key Points:
- Create and version a **GitHub repository** for Terraform modules.
- Publish the module to the **Terraform Public Registry**.
- Construct a root module to consume modules from the **Terraform Public Registry**.
- Understand **Terraform Module Versioning** to manage updates.

---

## Step-02: Create New GitHub Repository for Azure-Static-Website Terraform Module

1. **URL:** [github.com](https://github.com)
2. Click on **Create a new repository**.
3. Follow the **Naming Conventions** for Terraform modules:
   - `terraform-PROVIDER-MODULE_NAME`
   - Example: `terraform-azurerm-staticwebsitepublic`
4. **Repository Details:**
   - **Repository Name:** `terraform-azurerm-staticwebsitepublic`
   - **Description:** Terraform Modules to be shared in Terraform Public Registry
   - **Repo Type:** Public
   - **Initialize this repository with:**
     - **Uncheck**: Add a README file
     - **Check**: Add `.gitignore` (Template: Terraform)
     - **Check**: Choose a license (Optional, **Apache 2.0 License**)
5. Click **Create repository**.

---

## Step-03: Clone GitHub Repository to Local Desktop

Clone the GitHub repository to your local machine:

```bash
# Clone GitHub Repo
git clone https://github.com/<YOUR_GITHUB_ID>/<YOUR_REPO>.git
git clone https://github.com/stacksimplify/terraform-azurerm-staticwebsitepublic.git
```

---

## Step-04: Copy Files from `terraform-manifests` to Local Repo & Check-In Code

1. **Source Location from this section:** `terraform-azure-static-website-module-manifests`
2. **Destination Location:** The cloned GitHub repository folder `terraform-azurerm-staticwebsitepublic` on your local desktop.
3. **Check-In Code to Remote Repository:**

```bash
# Check Git Status
git status

# Commit changes locally
git add .
git commit -am "TF Module Files First Commit"

# Push to Remote Repository
git push

# Verify changes on Remote Repository
https://github.com/stacksimplify/terraform-azurerm-staticwebsitepublic.git
```

---

## Step-05: Create New Release Tag 1.0.0 in Repo

1. Go to the **Releases** section on your GitHub repository.
2. Click **Create a new release**.
3. Fill in the release details:
   - **Tag Version:** `1.0.0`
   - **Release Title:** `Release-1 terraform-azurerm-staticwebsitepublic`
   - **Write:** `Terraform Module for Public Registry - terraform-azurerm-staticwebsitepublic`
4. Click **Publish Release**.

---

## Step-06: Publish Module to Public Terraform Registry

1. Visit the Terraform Registry: [https://registry.terraform.io/](https://registry.terraform.io/).
2. Sign in using your **GitHub Account**.
3. Authorize Terraform Registry when prompted.
4. Go to **Publish** -> **Modules**.
5. **Select Repository on GitHub:** `terraform-azurerm-staticwebsitepublic`.
6. Check **"I agree to the Terms of Use"**.
7. Click **Publish Module**.

---

## Step-07: Review the Newly Published Module

1. **URL:** [Module on Terraform Registry](https://registry.terraform.io/modules/stacksimplify/staticwebsitepublic/azurerm/latest)
2. Review the module tabs on Terraform Cloud:
   - **Readme**
   - **Inputs**
   - **Outputs**
   - **Dependencies**
   - **Resources**
3. Also review the following:
   - **Versions**
   - **Provision Instructions**

---

## Step-08: Review Root Module Terraform Configs

1. In this step, we replace the local module reference with the **Terraform Public Registry** module.
2. Modify `c3-static-website.tf`:
   - **Comment** out the local module reference.
   - **Add** the module reference from the Terraform Public Registry.

```hcl
# Call our Custom Terraform Module which we built earlier
module "azure_static_website" {
  # source = "./modules/azure-static-website"  
  source  = "stacksimplify/staticwebsitepublic/azurerm"
  version = "1.0.0"

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

## Step-09: Execute Terraform Commands

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```
   **Observation:** You should see Terraform downloading the module and providers:
   ```
   Initializing modules...
   Downloading stacksimplify/staticwebsitepublic/azurerm 1.0.0 for azure_static_website...
   - azure_static_website in .terraform/modules/azure_static_website
   ```

2. **Validate Terraform Configuration:**
   ```bash
   terraform validate
   ```

3. **Format Configuration:**
   ```bash
   terraform fmt
   ```

4. **Plan the Configuration:**
   ```bash
   terraform plan
   ```

5. **Apply Configuration:**
   ```bash
   terraform apply -auto-approve
   ```

6. **Upload Static Content:**
   - Go to **Storage Accounts** -> `staticwebsitexxxxxx` -> **Containers** -> **$web**.
   - Upload files from the `static-content` folder.

### Verification:
- Confirm the **Azure Storage Account** is created.
- Ensure **Static Website Settings** are enabled.
- Verify **Static Content Upload** success.
- Access the website via the **Primary Endpoint** URL.

---

## Step-10: Destroy and Clean-Up

1. **Destroy Resources:**
   ```bash
   terraform destroy -auto-approve
   ```

2. **Delete Terraform Files:**
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   ```

---

## Step-11: Module Management on Terraform Public Registry

1. Go to the **Terraform Public Registry** at: [https://registry.terraform.io/modules/stacksimplify/staticwebsitepublic/azurerm/latest](https://registry.terraform.io/modules/stacksimplify/staticwebsitepublic/azurerm/latest).
2. As the module publisher, you can manage the module:
   - **Resync Module**
   - **Delete Module Version**
   - **Delete Module Provider**
   - **Delete Module**

---

## Step-12: Module Versioning

1. Make changes to your module code and push them to the GitHub repository.
2. On GitHub, create a new release tag (e.g., `2.0.0`).
3. Verify the new version in the Terraform Registry.
4. **Update the module version** in your Root Module configuration.

```bash
# Local Git Repo (e.g., update `Readme.md` file)
Just change `Readme.md` file
Add text `- Version 2.0.0`

# Git Commands
git status
git commit -am "2.0.0 Commit"
git push

# Draft a New Release
1. Go to Right Navigation on GitHub Repo -> Releases -> Draft a New Release
2. Tag Version: `2.0.0`
3. Release Title: `Release-2 terraform-azurerm-staticwebsitepublic`
4. Write: `Terraform Module for Public Registry - terraform-azurerm-staticwebsitepublic Release-2`
5. Click on **Publish Release**

# Verify in Terraform Registry
https://registry.terraform.io/modules/stacksimplify/staticwebsitepublic/azurerm/latest
In the Versions dropdown, you should now see both `1.0.0` and `2.0.0`.

# Update your Module Version tag in Root Module
**Old:** version = "1.0.0"
**New:** version = "2.0.0"
```

---

