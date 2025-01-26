# Terraform Remote State Datasource

**Description:** Learn how to use Terraform Remote State Datasource to manage resources across multiple projects, ensuring seamless sharing of state data.

---

## Step-01: Introduction

### Overview:
- Understand the [Terraform Remote State Datasource](https://www.terraform.io/docs/language/state/remote-state-data.html).
- Demonstration with two projects:
  1. **Project-1:** Creates and stores infrastructure state remotely.
  2. **Project-2:** Reads remote state data from Project-1 to build dependent resources.

---

## Step-02: Project-1: Terraform Configuration

### Files to Review:
1. `c1-versions.tf`
2. `c2-variables.tf`
3. `c3-locals.tf`
4. `c4-resource-group.tf`
5. `c5-virtual-network.tf`
6. `c6-outputs.tf`
7. `terraform.tfvars`

---

## Step-03: Project-1: Execute Terraform Commands

### Steps:
```bash
# Change Directory 
cd project-1-network

# Initialize Terraform
terraform init

# Validate Configuration
terraform validate

# Plan Resources
terraform plan

# Apply Configuration
terraform apply -auto-approve
```

### Observation:
1. Verify the created resources:
   - Resource Group
   - Virtual Network
   - Virtual Network Subnet
   - Public IP
   - Network Interface
2. Verify `terraform.tfstate` file in Azure Storage Account.

---

## Step-04: Project-2: Terraform Configuration

### Files to Review:
1. `c0-terraform-remote-state-datasource.tf`
2. `c1-versions.tf`
3. `c2-variables.tf`
4. `c3-locals.tf`
5. `c4-linux-virtual-machine.tf`
6. `c5-outputs.tf`
7. `terraform.tfvars`

---

## Step-05: Project-2: Remote State Datasource (`c0-terraform-remote-state-datasource.tf`)

### Configuration:
```hcl
# Terraform Remote State Datasource
data "terraform_remote_state" "project1" {
  backend = "azurerm"
  config = {
    resource_group_name   = "terraform-storage-rg"
    storage_account_name  = "terraformstate201"
    container_name        = "tfstatefiles"
    key                   = "network-terraform.tfstate"
  }
}

/*
Outputs Available:
1. Resource Group Name:
   data.terraform_remote_state.project1.outputs.resource_group_name
2. Resource Group Location:
   data.terraform_remote_state.project1.outputs.resource_group_location
3. Network Interface ID:
   data.terraform_remote_state.project1.outputs.network_interface_id
*/
```

---

## Step-06: Project-2: Virtual Machine Configuration (`c4-linux-virtual-machine.tf`)

### Changes in Virtual Machine Resource:
**Before (Single Project):**
```hcl
resource_group_name = azurerm_resource_group.myrg.name
location            = azurerm_resource_group.myrg.location
network_interface_ids = [azurerm_network_interface.myvmnic.id]
```

**After (Using Remote State):**
```hcl
resource_group_name = data.terraform_remote_state.project1.outputs.resource_group_name
location            = data.terraform_remote_state.project1.outputs.resource_group_location
network_interface_ids = [data.terraform_remote_state.project1.outputs.network_interface_id]
```

---

## Step-07: Project-2: Execute Terraform Commands

### Steps:
```bash
# Change Directory 
cd project-2-app1

# Initialize Terraform
terraform init

# Validate Configuration
terraform validate

# Plan Resources
terraform plan

# Apply Configuration
terraform apply -auto-approve
```

### Observation:
1. Verify dependent resources:
   - Resource Group
   - Virtual Network
   - Virtual Network Subnet
   - Public IP
   - Network Interface
   - Virtual Machine (including location and network interface).
2. Check the updated `terraform.tfstate` file in Azure Storage Account.

---

## Step-08: Project-2: Clean-Up

### Steps:
```bash
# Change Directory 
cd project-2-app1

# Destroy Resources
terraform destroy -auto-approve

# Delete Files
rm -rf .terraform*
```

---

## Step-09: Project-1: Clean-Up

### Steps:
```bash
# Change Directory 
cd project-1-network

# Destroy Resources
terraform destroy -auto-approve

# Delete Files
rm -rf .terraform*
```

---
