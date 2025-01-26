# Terraform Manage Providers

**Description:** Learn to manage and interact with **Terraform providers** through various commands such as locking provider versions, mirroring providers, and viewing provider schemas.

---

## Step-01: Introduction

### Key Points:
- **[Manage Terraform Providers](https://www.terraform.io/docs/cli/plugins/index.html)** provides various commands to interact with providers and manage their versions, configurations, and schemas.
  - `terraform providers`
  - `terraform version`
  - `terraform providers lock`
  - `terraform providers mirror`
  - `terraform providers schema -json`

---

## Step-02: Command: `terraform providers`

The `terraform providers` command shows information about the provider requirements of the configuration in the current working directory.

```bash
# Change Directory to your terraform-manifests folder
cd terraform-manifests/

# Show Terraform Providers information
terraform providers

# Sample Output:
Kalyans-Mac-mini:terraform-manifests kalyanreddy$ terraform providers

Providers required by configuration:
.
├── provider[registry.terraform.io/hashicorp/external] >= 2.0.0
├── provider[registry.terraform.io/hashicorp/azurerm] >= 2.0.0
└── provider[registry.terraform.io/hashicorp/random] >= 3.0.0

Kalyans-Mac-mini:terraform-manifests kalyanreddy$ 
```

---

## Step-03: Command: `terraform version`

The `terraform version` command displays the current version of Terraform and all installed plugins.

```bash
# Change Directory to your terraform-manifests folder
cd terraform-manifests/

# Show Terraform Version
terraform version

# Sample Output - Before terraform init
Kalyans-Mac-mini:terraform-manifests kalyanreddy$ terraform version
Terraform v1.0.0
Kalyans-Mac-mini:terraform-manifests kalyanreddy$ 

# Initialize Terraform
terraform init

# Show Terraform Version
terraform version

# Sample Output - After terraform init
Kalyans-Mac-mini:terraform-manifests kalyanreddy$ terraform version
Terraform v1.0.0
on darwin_amd64
+ provider registry.terraform.io/hashicorp/azurerm v2.65.0
+ provider registry.terraform.io/hashicorp/external v2.1.0
+ provider registry.terraform.io/hashicorp/random v3.1.0
Kalyans-Mac-mini:terraform-manifests kalyanreddy$ 
```

---

## Step-04: Command: `terraform providers lock`

The `terraform providers lock` command fetches provider dependency information from upstream registries and writes it into the **dependency lock file**.

**Important Note:** This command does not verify the trustworthiness of the providers; you must manually review the signing key information before committing the lock file.

```bash
# Change Directory to your terraform-manifests folder
cd terraform-manifests/

# Lock the providers
terraform providers lock

# This will create the file ".terraform.lock.hcl"
# Initialize Terraform after locking
terraform init
```

---

## Step-05: Command: `terraform providers lock` for All Supported Platforms

To ensure compatibility across multiple platforms (Windows, MacOS, Linux), we generate the lock file for all platforms, enabling consistency when running Terraform on different systems.

```bash
# Backup existing ".terraform.lock.hcl" file
cp .terraform.lock.hcl .terraform.lock.hcl_macosonly

# Lock providers for all platforms
terraform providers lock -platform=windows_amd64 -platform=darwin_amd64 -platform=linux_amd64

# Compare the old and new lock files
diff .terraform.lock.hcl_macosonly .terraform.lock.hcl
```

---

## Step-06: Command: `terraform providers mirror`

The `terraform providers mirror` command downloads and stores providers required for the configuration into a specified local directory.

```bash
# Change Directory to your terraform-manifests folder
cd terraform-manifests/

# Create a directory to mirror the providers
mkdir ../mirror1

# Mirror providers to the directory
terraform providers mirror ../mirror1

# Verify the mirrored content
ls -lrt ../mirror1/
ls -lrt ../mirror1/registry.terraform.io/hashicorp/
```

---

## Step-07: Command: `terraform providers mirror` for Multiple Platforms

This command allows you to mirror providers for multiple platforms, ensuring cross-platform compatibility for environments such as local workstations and CI/CD pipelines.

```bash
# Change Directory to your terraform-manifests folder
cd terraform-manifests/

# Create a directory to mirror providers for multiple platforms
mkdir ../mirror2-multiplatforms

# Mirror providers for multiple platforms
terraform providers mirror -platform=windows_amd64 -platform=darwin_amd64 -platform=linux_amd64 ../mirror2-multiplatforms/

# Verify the mirrored content
ls -lrt ../mirror2-multiplatforms/
ls -lrt ../mirror2-multiplatforms/registry.terraform.io/hashicorp/
ls -lrt ../mirror2-multiplatforms/registry.terraform.io/hashicorp/azurerm

# Clean-Up
rm -rf ../mirror1
rm -rf ../mirror2-multiplatforms
```

---

## Step-08: Command: `terraform providers schema`

The `terraform providers schema` command prints detailed schemas for the providers used in the current configuration.

```bash
# Change Directory to your terraform-manifests folder
cd terraform-manifests/

# Initialize Terraform before running schema command
terraform init

# Get providers schema in JSON format
terraform providers schema -json

# Format the JSON output with jq for better readability
terraform providers schema -json | jq

# Save the schema to a file
terraform providers schema -json | jq > all-providers-schema.json
```

---

## Step-09: Review the `all-providers-schema.json` in VS Code

You can review the entire provider schema in your code editor (e.g., VS Code) to understand the structure of each provider.

---

## Step-10: Clean-Up

After completing the steps, clean up by removing the `.terraform` directory and the `.terraform.lock.hcl` file.

```bash
# Clean up Terraform files
rm -rf .terraform*

# Leave the schema file for future reference
# all-providers-schema.json remains in the working directory
```

---
