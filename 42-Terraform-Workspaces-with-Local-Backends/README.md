# Terraform Workspaces with Local Backend

**Description:** Learn how to use Terraform workspaces with the local backend to manage multiple environments within a single configuration directory.

---

## Step-01: Introduction

### Overview:
- Use Terraform's **local backend** to create and manage multiple workspaces.
- Key focus:
  - Create additional workspaces like `dev` alongside the default workspace.
  - Update Terraform configurations to leverage `${terraform.workspace}` for workspace-specific resource naming and behavior.

### Commands to Master:
1. `terraform workspace show`
2. `terraform workspace list`
3. `terraform workspace new`
4. `terraform workspace select`
5. `terraform workspace delete`

---

## Step-02: Review and Update Terraform Configurations

### Source:
- Copy configurations from `38-Terraform-Remote-State-Storage-and-Locking`.

---

## Step-03: Remove Backend Block

Remove any remote backend configuration from `c1-versions.tf`:
```hcl
# Remove backend block
backend "azurerm" {
  resource_group_name   = "terraform-storage-rg"
  storage_account_name  = "terraformstate201"
  container_name        = "tfstatefiles"
  key                   = "terraform.tfstate"
}
```

---

## Step-04: Update `c3-locals.tf`

Use `${terraform.workspace}` for resource naming:
```hcl
locals {
  rg_name = "${var.business_unit}-${terraform.workspace}-${var.resoure_group_name}"
  vnet_name = "${var.business_unit}-${terraform.workspace}-${var.virtual_network_name}"
  snet_name = "${var.business_unit}-${terraform.workspace}-${var.subnet_name}"
  pip_name = "${var.business_unit}-${terraform.workspace}-${var.publicip_name}"
  nic_name = "${var.business_unit}-${terraform.workspace}-${var.network_interface_name}"
  vm_name = "${var.business_unit}-${terraform.workspace}-${var.virtual_machine_name}"
}
```

---

## Step-05: Update `c5-virtual-network.tf`

Update the `domain_name_label` for the Public IP:
```hcl
resource "azurerm_public_ip" "mypublicip" {
  name                = local.pip_name
  resource_group_name = azurerm_resource_group.myrg.name
  location            = azurerm_resource_group.myrg.location
  allocation_method   = "Static"
  domain_name_label   = "app1-${terraform.workspace}-${random_string.myrandom.id}"
  tags                = local.common_tags
}
```

---

## Step-06: Create Resources in Default Workspace

### Steps:
1. **Initialize Terraform:**
   ```bash
   terraform init
   ```
2. **Verify Default Workspace:**
   ```bash
   terraform workspace list
   terraform workspace show
   ```
3. **Plan and Apply:**
   ```bash
   terraform plan
   terraform apply -auto-approve
   ```
4. **Observation:**
   - Resource names will include `default` (e.g., `it-default-rg`, `it-default-vnet`).

5. **Verify in Azure Management Console:**
   - Confirm resource naming includes `default`.

6. **Access the Application:**
   ```bash
   http://<public-ip-dns-name>
   ```

---

## Step-07: Create and Use a New Workspace (`dev`)

### Steps:
1. **Create Workspace:**
   ```bash
   terraform workspace new dev
   ```
2. **Verify Directory:**
   ```bash
   cd terraform.tfstate.d/dev
   ls
   cd ../../
   ```
3. **Plan and Apply:**
   ```bash
   terraform plan
   terraform apply -auto-approve
   ```
4. **Observation:**
   - Resource names will include `dev` (e.g., `it-dev-rg`, `it-dev-vnet`).

5. **Verify in Azure Management Console:**
   - Confirm resource naming includes `dev`.

6. **Access the Application:**
   ```bash
   http://<public-ip-dns-name>
   ```

---

## Step-08: Switch Workspace and Destroy Resources

### Steps:
1. **Switch to Default Workspace:**
   ```bash
   terraform workspace select default
   ```
2. **Destroy Resources in Default Workspace:**
   ```bash
   terraform destroy -auto-approve
   ```
3. **Verify in Azure Management Console:**
   - All `default` workspace resources should be deleted.

---

## Step-09: Delete the `dev` Workspace

### Steps:
1. **Destroy Resources in `dev`:**
   ```bash
   terraform workspace select dev
   terraform destroy -auto-approve
   ```
2. **Switch to Default Workspace:**
   ```bash
   terraform workspace select default
   ```
3. **Delete the `dev` Workspace:**
   ```bash
   terraform workspace delete dev
   ```
4. **Observation:**
   - The `dev` workspace is successfully deleted.

---

## Step-10: Clean-Up

### Steps:
1. **Remove Local Files:**
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   ```

---

## References

1. [Terraform Workspaces](https://www.terraform.io/docs/language/state/workspaces.html)
2. [Managing Workspaces](https://www.terraform.io/docs/cli/workspaces/index.html)

---
