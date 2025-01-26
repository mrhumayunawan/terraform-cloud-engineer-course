# Terraform State Commands

**Description:** Master Terraform state management commands for inspecting, modifying, and troubleshooting Terraform state files.

---

## Step-00: Introduction

### Key Commands:
1. `terraform show`
2. `terraform state`
3. `terraform force-unlock`
4. `terraform taint`
5. `terraform untaint`
6. `terraform apply -target`

---

## Step-01: Review Terraform Configurations

### Files:
1. `c1-versions.tf`
2. `c2-variables.tf`
3. `c3-local-values.tf`
4. `c4-resource-group.tf`
5. `c5-virtual-network.tf`
6. `c6-datasource-subscription.tf`

---

## Step-02: Update Terraform Backend Key

Update the Terraform backend key in `c1-versions.tf`:
```hcl
backend "azurerm" {
  resource_group_name   = "terraform-storage-rg"
  storage_account_name  = "terraformstate201"
  container_name        = "tfstatefiles"
  key                   = "state-commands-demo1.tfstate"
}
```

---

## Step-03: Terraform Show Command

The `terraform show` command is used to display human-readable output from a state or plan file.

### Steps:
1. **Generate a Plan File:**
   ```bash
   terraform init
   terraform validate
   terraform plan -out=v1plan.out
   ```
2. **View the Plan:**
   ```bash
   terraform show v1plan.out
   terraform show  # Displays state file if `terraform.tfstate` exists
   ```
3. **View in JSON Format:**
   ```bash
   terraform show -json v1plan.out | jq
   ```

---

## Step-04: Reading State Files with Terraform Show

If the `terraform.tfstate` file exists in the working directory:
```bash
terraform show
```

### Steps:
1. **Create Resources:**
   ```bash
   terraform apply v1plan.out
   ```
2. **Inspect the State File:**
   ```bash
   terraform show
   ```

---

## Step-05: Terraform State Commands

### Step 5.1: Inspect State
1. **List Resources in State:**
   ```bash
   terraform state list
   ```
2. **Show Resource Attributes:**
   ```bash
   terraform state show <RESOURCE_NAME>
   terraform state show azurerm_virtual_network.myvnet
   ```

### Step 5.2: Move Resources in State
- Move a resource to a new name in the state file:
   ```bash
   terraform state mv azurerm_virtual_network.myvnet azurerm_virtual_network.myvnet-new
   ```
- Verify the changes:
   ```bash
   terraform state list
   terraform plan
   ```

### Step 5.3: Remove Resources from State
1. Remove a resource:
   ```bash
   terraform state rm azurerm_virtual_network.myvnet-new
   ```
2. Decision Options:
   - **Choice-1:** Remove the resource from manifests if it should no longer be Terraform-managed.
   - **Choice-2:** Update manifests to recreate the resource with a new configuration.

---

## Step-06: Terraform Force-Unlock

If a state file becomes locked:
```bash
terraform force-unlock <LOCK_ID>
```

---

## Step-07: Terraform Taint and Untaint Commands

1. **Taint a Resource:**
   ```bash
   terraform taint azurerm_virtual_network.myvnet
   ```
2. **Untaint a Resource:**
   ```bash
   terraform untaint azurerm_virtual_network.myvnet
   ```

---

## Step-08: Resource Targeting with `-target`

The `-target` option allows Terraform to apply or plan for specific resources only.

### Example:
1. **Modify `c5-virtual-network.tf`:**
   ```hcl
   address_space = ["10.0.0.0/16", "10.1.0.0/16"]
   ```
2. **Plan and Apply Targeted Resource:**
   ```bash
   terraform plan -target=azurerm_virtual_network.myvnet
   terraform apply -target=azurerm_virtual_network.myvnet
   ```

---

## Step-09: Disaster Recovery: State Pull/Push

1. **Pull the State File:**
   ```bash
   terraform state pull > terraform.tfstate
   ```
2. **Push a Local State File:**
   ```bash
   terraform state push terraform.tfstate
   ```

---

## Step-10: Cleanup

### Destroy Resources:
```bash
terraform destroy -auto-approve
```

### Remove Files:
```bash
rm -rf .terraform* terraform.tfstate* v1plan.out
```

---

## References

- [Terraform State Commands](https://www.terraform.io/docs/cli/commands/state/index.html)
- [Terraform Inspect State](https://www.terraform.io/docs/cli/state/inspect.html)
- [Terraform Disaster Recovery](https://www.terraform.io/docs/cli/state/recover.html)
- [Terraform Resource Targeting](https://www.terraform.io/docs/cli/commands/plan.html#resource-targeting)

---
