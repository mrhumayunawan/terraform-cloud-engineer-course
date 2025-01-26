# Terraform Command `apply -refresh-only`

**Description:** Learn how to use `terraform apply -refresh-only` to synchronize the Terraform state file with real-world infrastructure without making changes to the infrastructure.

---

## Step-01: Introduction

### Overview:
- [Terraform Refresh Command](https://www.terraform.io/docs/cli/commands/refresh.html) is a state inspection tool.
- The `apply -refresh-only` command helps reconcile Terraform's state file (`terraform.tfstate`) with actual cloud resources.
  
### Key Concepts:
- **Desired State:** Configuration in Terraform files (`*.tf`).
- **Current State:** The actual resources in the cloud.
- **State File:** A record of Terraform’s last known state of infrastructure.

### Benefits:
- Detect drift between configuration and the real-world state.
- Update the Terraform state file without modifying infrastructure.
- Identify changes made outside Terraform (e.g., manual cloud console edits).

---

## Step-02: Review Terraform Configurations

### Files:
1. `c1-versions.tf`
2. `c2-resource-group.tf`

---

## Step-03: Execute Terraform Commands

### Steps:
1. **Initialize Terraform:**
   ```bash
   terraform init
   ```
2. **Validate Configuration:**
   ```bash
   terraform validate
   ```
3. **Plan Resources:**
   ```bash
   terraform plan
   ```
4. **Apply Configuration:**
   ```bash
   terraform apply -auto-approve
   ```

### Observation:
- Verify the resource group is created as defined in the configuration.

---

## Step-04: Simulate Drift (Manual Cloud Changes)

1. **Add a Tag Manually via Azure Portal:**
   ```json
   "tag3" = "my-tag-3"
   ```
2. This creates a drift between Terraform's state file and the real-world infrastructure.

---

## Step-05: Execute `terraform plan`

1. **Run Terraform Plan:**
   ```bash
   terraform plan
   ```
   
2. **Observation:**
   - Plan output will detect drift but not update the state file.
   - The difference will show the missing tag (`tag3`).

3. **Verify State File:**
   ```bash
   terraform show
   ```
   - The state file will not reflect the manually added tag.

---

## Step-06: Execute `terraform apply -refresh-only`

1. **Run Refresh Plan:**
   ```bash
   terraform plan -refresh-only
   ```

2. **Apply the Refresh:**
   ```bash
   terraform apply -refresh-only
   ```

3. **Verify the State File:**
   ```bash
   terraform show
   ```
   - The state file now includes the manually added tag (`tag3`).

4. **Observation:**
   - The infrastructure remains unchanged.
   - The state file is updated to match the real-world configuration.

---

## Step-07: Update Terraform Configuration

1. **Edit `c2-resource-group.tf`:**
   ```hcl
   resource "azurerm_resource_group" "myrg" {
     name     = "myrg1"
     location = "eastus"
     tags = {
       "tag1" = "my-tag-1"
       "tag2" = "my-tag-2"
       "tag3" = "my-tag-3"
     }
   }
   ```

2. **Run Terraform Plan:**
   ```bash
   terraform plan
   ```

3. **Observation:**
   - No changes are required.
   - The desired state, current state, and the state file are now synchronized.

---

## Step-08: Clean-Up

1. **Destroy Resources:**
   ```bash
   terraform destroy -auto-approve
   ```

2. **Remove Local Files:**
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   ```

---

## References

- [Terraform Refresh Command](https://www.terraform.io/docs/cli/commands/refresh.html)
- [Managing State](https://www.terraform.io/docs/language/state/index.html)
- [State Inspection Tools](https://www.terraform.io/docs/cli/state/inspect.html)

---
