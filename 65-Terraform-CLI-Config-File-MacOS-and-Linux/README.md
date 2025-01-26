# Terraform CLI Config File MacOS and LinuxOS

**Description:** Learn how to configure and manage the **Terraform CLI Config File** for **MacOS** and **LinuxOS**, including setting up plugin cache and Terraform Cloud credentials.

---

## Step-01: Introduction

### Key Points:
- **[Terraform CLI Config File](https://www.terraform.io/docs/cli/config/config-file.html)** is used to configure various settings for Terraform operations.
  - **Windows:** `terraform.rc`
  - **Linux, MacOS:** `.terraformrc`
- **plugin_cache_dir**: A directory where Terraform caches plugins to avoid re-downloading them in future runs.

---

## Step-02: Create `.terraformrc` in User Home Directory

To create the Terraform CLI config file, follow these steps:

```bash
# Change Directory to Home
cd $HOME

# Create Terraform CLI Config File
touch .terraformrc
```

---

## Step-03: Update `.terraformrc` with Plugin Cache Folder

Next, you’ll update the `.terraformrc` file to specify the plugin cache directory.

```bash
# Update File
vi $HOME/.terraformrc

# Add the following content
plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"
disable_checkpoint = true

# Create the Plugin Cache Directory
mkdir -p $HOME/.terraform.d/plugin-cache
```

---

## Step-04: Execute Terraform Commands

Now, run Terraform commands to initialize your configuration and verify the plugin cache directory.

```bash
# Change Directory 
cd 65-Terraform-CLI-Config-File-MacOS-and-Linux/terraform-manifests

# Terraform Initialize
terraform init

# Verify the contents in Plugin Cache Directory
ls -lrta $HOME/.terraform.d/plugin-cache
cd $HOME/.terraform.d/plugin-cache
ls
cd $HOME/.terraform.d/plugin-cache/registry.terraform.io/hashicorp/
ls
```

---

## Step-05: Verify if Plugins Loaded from Cache

Let’s test if the plugins are being correctly loaded from the cache directory.

```bash
# Change Directory 
cd 65-Terraform-CLI-Config-File-MacOS-and-Linux/terraform-manifests

# Remove .terraform Folder (which contains plugins)
rm -rf .terraform*

# Terraform Initialize
terraform init

# Sample Output for Reference
Kalyans-Mac-mini:terraform-manifests kalyanreddy$ terraform init
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/azurerm versions matching ">= 2.0.0"...
- Finding hashicorp/random versions matching ">= 3.0.0"...
- Finding hashicorp/external versions matching ">= 2.0.0"...
- Using hashicorp/random v3.1.0 from the shared cache directory
- Using hashicorp/external v2.1.0 from the shared cache directory
- Using hashicorp/azurerm v2.65.0 from the shared cache directory

# Observation:
# 1. You should see provider plugins loaded from the "shared cache directory."
```

---

## Step-07: Clean-Up

After testing, clean up the environment by removing the `.terraform` folder and other files if necessary.

```bash
# Remove .terraform Folder which contains plugins
rm -rf .terraform*
```

---

## Step-08: Terraform Cloud Credentials

You can define **Terraform Cloud credentials** globally in your `.terraformrc` file to authenticate with Terraform Cloud using a token.

- **[Terraform Cloud Credentials](https://www.terraform.io/docs/cli/config/config-file.html#credentials-1)**

```bash
# Add Terraform Cloud Credentials to .terraformrc
credentials "app.terraform.io" {
  token = "xxxxxx.atlasv1.zzzzzzzzzzzzz"
}
```

---
