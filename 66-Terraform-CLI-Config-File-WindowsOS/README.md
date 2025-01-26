# Terraform CLI Config File Windows OS

**Description:** Learn how to configure and manage the **Terraform CLI Config File** on **Windows OS**, including setting up the plugin cache and executing Terraform commands.

---

## Step-01: Introduction

### Key Points:
- **[Terraform CLI Config File](https://www.terraform.io/docs/cli/config/config-file.html)** is used to configure various settings for Terraform operations.
  - **Windows**: `terraform.rc` is the configuration file.
  
---

## Step-02: Create `terraform.rc` in User Home Directory

On Windows, the **CLI config file** must be named **`terraform.rc`** and placed in the relevant user's **`%APPDATA%`** directory. Use `$env:APPDATA` in **PowerShell** to find its location on your system.

**Important Note:**
- Windows Explorer might hide file extensions by default, so ensure the file is named exactly `terraform.rc` and not `terraform.rc.txt`.
- You can confirm the correct filename using **`dir`** in **PowerShell** or **Command Prompt**.

```powershell
# Find location of the AppData directory
$env:APPDATA

# Create a folder for plugin cache
New-Item -ItemType Directory -Force -Path "C:\Users\Administrator\Documents\plugin_cache"
```

---

## Step-03: Update `terraform.rc` with Plugin Cache Folder

Update the `terraform.rc` file to specify the plugin cache directory, ensuring that plugins are stored for faster access.

```bash
# Update terraform.rc file with plugin cache directory
plugin_cache_dir = "C:/Users/Administrator/Documents/plugin_cache"
disable_checkpoint = true
```

---

## Step-04: Execute Terraform Commands

Now, execute Terraform commands to initialize your configuration and verify the plugin cache directory.

```bash
# Change Directory to your terraform manifests folder
cd 66-Terraform-CLI-Config-File-WindowsOS/terraform-manifests

# Initialize Terraform
terraform init

# Verify the contents in Plugin Cache Directory
C:\Users\Administrator\Documents\plugin_cache
C:\Users\Administrator\Documents\plugin_cache\registry.terraform.io\hashicorp
```

---

## Step-05: Verify if Plugins Loaded from Cache

To verify that Terraform loads the plugins from the cache directory, follow these steps:

```bash
# Change Directory to your terraform manifests folder
cd 66-Terraform-CLI-Config-File-WindowsOS/terraform-manifests

# Delete the .terraform Folder (which contains the plugins)
Remove-Item -Recurse -Force .terraform

# Initialize Terraform again
terraform init

# Sample Output for Reference
PS C:\Users\Administrator\Downloads\hashicorp-certified-terraform-associate-on-azure-main\hashicorp-certified-terraform-associate-on-azure-main\66-Terraform-CLI-Config-File-WindowsOS\terraform-manifests> terraform init

Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/external versions matching ">= 2.0.0"...
- Finding hashicorp/azurerm versions matching ">= 2.0.0"...
- Finding hashicorp/random versions matching ">= 3.0.0"...
- Using hashicorp/random v3.1.0 from the shared cache directory
- Using hashicorp/external v2.1.0 from the shared cache directory
- Using hashicorp/azurerm v2.65.0 from the shared cache directory
```

---

## Step-07: Clean-Up

After verifying the functionality, you can clean up by removing the `.terraform` folder and any related files.

```bash
# Remove .terraform Folder (which contains plugins)
Remove-Item -Recurse -Force .terraform

# Also remove the .terraform.lock.hcl file if exists
Remove-Item .terraform.lock.hcl
```

---
