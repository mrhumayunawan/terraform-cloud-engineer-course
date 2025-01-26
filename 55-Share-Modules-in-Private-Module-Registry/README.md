# Share Terraform Modules in Private Modules Registry

**Description:** Learn how to share Terraform modules in a private module registry and use them in your Terraform Cloud workspace.

---

## Step-01: Introduction

### Key Points:
- Create and version a **GitHub repository** for use in the private module registry.
- **Import a module** into your organization's private module registry.
- **Construct a root module** to consume modules from the private registry.
- Learn about the `terraform login` command and how it integrates with private module registries.

---

## Step-02: Create New Private GitHub Repository for Azure Static Website Terraform Module

1. **URL:** [github.com](https://github.com)
2. Click on **Create a new repository**.
3. Follow **Naming Conventions** for modules:
   - `terraform-PROVIDER-MODULE_NAME`
   - Example: `terraform-azurerm-staticwebsiteprivate`
4. **Repository Details:**
   - **Repository Name:** `terraform-azurerm-staticwebsiteprivate`
   - **Description:** `Terraform Modules to be shared in Private Registry`
   - **Repo Type:** Private (The repository will be made public for students after the demo)
   - **Initialize this repository with:**
     - **UN-CHECK**: Add a README file
     - **CHECK**: Add `.gitignore`
     - **Select `.gitignore Template`:** Terraform
     - **CHECK**: Choose a license (optional)
     - **Select License:** Apache 2.0 License
5. Click on **Create repository**.

---

## Step-03: Clone GitHub Repository to Local Desktop

```bash
# Clone GitHub Repo
git clone https://github.com/<YOUR_GITHUB_ID>/<YOUR_REPO>.git
git clone https://github.com/stacksimplify/terraform-azurerm-staticwebsiteprivate.git
```

---

## Step-04: Copy Files from `terraform-manifests` to Local Repo & Check-In Code

1. **Source Location from this section:** `terraform-azure-static-website-module-manifests`
2. **Destination Location:** The cloned GitHub repository folder `terraform-azurerm-staticwebsiteprivate` on your local desktop.

### Check-In Code to Remote Repository:

```bash
# GIT Status
git status

# Git Local Commit
git add .
git commit -am "TF Module Files First Commit"

# Push to Remote Repository
git push

# Verify the same on Remote Repository
https://github.com/stacksimplify/terraform-azurerm-staticwebsiteprivate.git
```

---

## Step-05: Create New Release Tag 1.0.0 in Repo

1. Go to the **Releases** section on your GitHub repository.
2. Click **Create a new release**.
3. Fill in the release details:
   - **Tag Version:** `1.0.0`
   - **Release Title:** `Release-1 terraform-azure-staticwebsiteprivate`
   - **Write:** `Terraform Module for Private Registry on Terraform Cloud - terraform-azure-staticwebsiteprivate`
4. Click **Publish Release**.

---

## Step-06: Add VCS Provider as GitHub using OAuth App in Terraform Cloud

### Step-06-01: Add VCS Provider as GitHub Using OAuth App in Terraform Cloud

1. **Login to Terraform Cloud**.
2. Go to **Organization** `hcta-azure-demo1` -> **Registry Tab**.
3. Click on **Publish Private Module** -> Select **GitHub (Custom)**.
4. If no OAuth Apps are configured, it will redirect to [GitHub OAuth Application Settings](https://github.com/settings/applications/new).
   - **Application Name:** Terraform Cloud (`hctaazuredemo1`)
   - **Homepage URL:** [https://app.terraform.io](https://app.terraform.io)
   - **Application Description:** Terraform Cloud Integration with GitHub using OAuth.
   - **Authorization Callback URL:** [https://app.terraform.io/auth/358abc4a-c3c9-4c49-9ddd-354d75d6fe85/callback](https://app.terraform.io/auth/358abc4a-c3c9-4c49-9ddd-354d75d6fe85/callback)
5. Click **Register Application**.
6. Make a note of the **Client ID** and **Client Secret** for future use.

### Step-06-02: Add the OAuth Details in Terraform Cloud

1. **Name:** `github-terraform-modules-for-azure`
2. **Client ID:** `ad55bce90463ff34bb56` (sample for reference)
3. **Client Secret:** `ff3e6a4343cad08694ddfa3bfd0bd50c429f941a`
4. Click **Connect and Continue**.
5. Authorize **Terraform Cloud** (`hctaazuredemo1`) to access your GitHub repositories.
6. **SSH Keypair (Optional):** Skip and click **Finish**.

---

## Step-06: Import the Terraform Module from GitHub

1. Go to **Organization** `hcta-azure-demo1` -> **Registry Tab**.
2. Click on **Publish Private Module** -> Select **GitHub** (github-terraform-modules-for-azure).
3. **Choose a Repository:** `terraform-azurerm-staticwebsiteprivate`.
4. Click **Publish Module**.

---

## Step-07: Review Newly Imported Module

1. Login to **Terraform Cloud** -> Click on **Modules Tab**.
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

## Step-08: Create a Configuration that Uses the Private Registry Module Using Terraform CLI

Create a Terraform configuration in the root module by calling the newly published module in Terraform's private registry.

### `c3-static-website.tf`:

```hcl
# Call our Custom Terraform Module which we built earlier
module "azure_static_website" {
  # source = "./modules/azure-static-website"  
  # source  = "stacksimplify/staticwebsitepb/azurerm"
  source  = "app.terraform.io/hcta-azure-demo1-internal/staticwebsiteprivate/azurerm"
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

1. **Change Directory:**
   ```bash
   cd 55-Share-Modules-in-Private-Module-Registry/terraform-manifests
   ```

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```
   **Observation:** You should see an error due to the CLI not having access to the Private Module Registry in Terraform Cloud.

   **Sample Output:**
   ```
   Error: Error accessing remote module registry
   Failed to retrieve available versions for module "azure_static_website": error looking up module versions: 401 Unauthorized.
   ```

3. **Terraform Login:**
   ```bash
   terraform login
   ```
   **Observation:** You should see the message: `Retrieved token for user stacksimplify`.

4. **Verify the Credentials File:**
   ```bash
   cat /Users/<YOUR_USER>/.terraform.d/credentials.tfrc.json
   ```

   **Sample Output:**
   ```json
   {
     "credentials": {
       "app.terraform.io": {
         "token": "your-token-value"
       }
     }
   }
   ```

5. **Reinitialize Terraform:**
   ```bash
   terraform init
   ```
   **Observation:** This should successfully download the modules and providers.

6. **Run Terraform Validate:**
   ```bash
   terraform validate
   ```

7. **Run Terraform Plan:**
   ```bash
   terraform plan
   ```

8. **Run Terraform Apply:**
   ```bash
   terraform apply -auto-approve
   ```

9. **Upload Static Content:**
   - Go to **Storage Accounts** -> `staticwebsitexxxxxx` -> **Containers** -> **$web**.
   - Upload files from the `static-content` folder.

10. **Verify:**
    - Verify the **Azure Storage Account** is created.
    - Confirm that the **Static Website Setting** is enabled.
    - Verify if the **Static Content** was uploaded successfully.
    - Access the **Static Website** via the **Primary Endpoint** URL:
      `https://staticwebsitek123.z13.web.core.windows.net/`.

---

## Step-10: Destroy and Clean-Up

1. **Terraform Destroy:**
   ```bash
   terraform destroy -auto-approve
   ```

2. **Delete Terraform Files:**
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   ```

---

## Step-11: Create a Configuration that Uses the Private Registry Module Using Terraform Cloud & GitHub

### Assignment:
1. Create a **GitHub repository**.
2. Check in files from the `terraform-manifests` folder in the `55-Share-Modules-in-Private-Module-Registry` section.
3. Create a new **Workspace** with **VCS workflow** in **Terraform Cloud** to connect with the **GitHub Repository**.
4. Execute `Queue Plan` to apply the changes and test.

---

## Step-12: VCS Providers & Terraform Cloud

- [Configuration-Free GitHub Usage](https://www.terraform.io/docs/cloud/vcs/github-app.html)
- [Configuring GitHub.com Access (OAuth)](https://www.terraform.io/docs/cloud/vcs/github.html)
- [Configuring GitHub Enterprise Access](https://www.terraform.io/docs/cloud/vcs/github-enterprise.html)
- [Other Supported VCS Providers](https://www.terraform.io/docs/cloud/vcs/index.html)

---

