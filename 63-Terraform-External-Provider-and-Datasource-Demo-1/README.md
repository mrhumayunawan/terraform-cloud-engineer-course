# Terraform External Provider and Datasource

**Description:** Learn how to use the **Terraform External Provider** and **External Data Sources** to run external scripts and fetch data dynamically during your Terraform executions.

---

## Step-01: Introduction

### Key Points:
- **[Terraform External Provider and Datasource](https://registry.terraform.io/providers/hashicorp/external/latest)** allow you to execute external scripts and fetch data from outside Terraform during the execution of your infrastructure code.
- External resources are used when you need Terraform to interact with systems or services outside of the typical Terraform providers.
- You can use external providers to run shell scripts, interact with APIs, or manage configurations that Terraform does not natively support.

---

## Step-02: Pre-requisite Installs

Before using the Terraform External Provider, make sure you have these tools installed:

```bash
# Check for ssh-keygen
which ssh-keygen

# Check for jq
which jq

# If jq is not installed, install it using Homebrew (for macOS/Linux)
brew install jq
```

---

## Step-03: `ssh_key_generator.sh`

This shell script generates an SSH key pair. It accepts inputs using `jq` and produces the keys as output. The script is located in `terraform-manifests/shell-scripts`.

```bash
function error_exit() {
  echo "$1" 1>&2
  exit 1
}

function check_deps() {
  test -f $(which ssh-keygen) || error_exit "ssh-keygen command not found in path, please install it"
  test -f $(which jq) || error_exit "jq command not found in path, please install it"
}

function parse_input() {
  # jq reads from stdin so we don't have to set up any inputs, but let's validate the outputs
  eval "$(jq -r '@sh "export KEY_NAME=\(.key_name) KEY_ENVIRONMENT=\(.key_environment)"')"
  if [[ -z "${KEY_NAME}" ]]; then export KEY_NAME=none; fi
  if [[ -z "${KEY_ENVIRONMENT}" ]]; then export KEY_ENVIRONMENT=none; fi
}

function create_ssh_key() {
  script_dir=$(dirname $0)
  export ssh_key_file="${script_dir}/${KEY_NAME}-${KEY_ENVIRONMENT}"
  if [[ ! -f "${ssh_key_file}" ]]; then
    ssh-keygen -q -m PEM -t rsa -b 4096 -N '' -f $ssh_key_file
  fi
}

function produce_output() {
  public_key_contents=$(cat ${ssh_key_file}.pub)
  private_key_contents=$(cat ${ssh_key_file} | awk '$1=$1' ORS='  \n')
  jq -n \
    --arg public_key "$public_key_contents" \
    --arg private_key "$private_key_contents" \
    --arg private_key_file "$ssh_key_file" \
    '{"public_key":$public_key,"private_key":$private_key,"private_key_file":$ssh_key_file}'
}

# main()
check_deps
parse_input
create_ssh_key
produce_output
```

---

## Step-04: Test Shell Script

To test the shell script, run it with the input JSON object and verify the SSH key files created.

```bash
# Test Shell Script
echo '{"key_name": "terraformdemo", "key_environment": "dev"}' | ./ssh_key_generator.sh

# Verify the files created
# Files created:
# terraform-manifests/shell-scripts/
# 1. terraformdemodev: Private key file created
# 2. terraformdemodev.pub: Public Key file created
```

---

## Step-05: `c1-versions.tf`

This file includes the necessary provider configurations, including the **external provider** for the Terraform External Provider.

```hcl
# Terraform Block
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.0" 
    }
    external = {
      source = "hashicorp/external"
      version = ">= 2.0"
    }       
  }
}

# Provider Block
provider "azurerm" {
  features {}          
}
```

---

## Step-06: `c2-external-datasource.tf`

This configuration sets up an **external datasource** to run the **SSH key generation script** (`ssh_key_generator.sh`).

```hcl
# External Datasource
data "external" "ssh_key_generator" {
  program = ["bash", "${path.module}/shell-scripts/ssh_key_generator.sh"]
  
  query = {
    key_name     = "terraformdemo"
    key_environment = "dev"
  }
}
```

---

## Step-07: `c2-external-datasource.tf - Outputs`

Here we define Terraform **outputs** that retrieve the generated SSH keys from the external data source.

```hcl
# Outputs
output "public_key" {
  description = "public_key"
  value = data.external.ssh_key_generator.result.public_key
}

output "private_key" {
  description = "private_key"
  value = data.external.ssh_key_generator.result.private_key
}

output "private_key_file" {
  description = "private_key_file"
  value = data.external.ssh_key_generator.result.private_key_file 
}
```

---

## Step-08: Execute Terraform Commands

Now, run Terraform commands to test the external data source.

```bash
# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Observation
# 1. This is just a datasource, so either `terraform plan` or `terraform apply` will trigger the shell script to generate SSH keys.

# Terraform Apply (Optional)
terraform apply 
```

---

## Step-09: Clean-Up

If `terraform apply` was executed, you can destroy the resources. Otherwise, just clean up your environment.

```bash
# Destroy Resources (Optional if terraform apply not executed)
terraform destroy -auto-approve 

# Delete Files
rm -rf .terraform* 
rm -rf terraform.tfstate*
```

---
