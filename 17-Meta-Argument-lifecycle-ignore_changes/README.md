# Terraform Meta-Argument `lifecycle ignore_changes`

**Description:** Learn how to use the Terraform resource `lifecycle` meta-argument `ignore_changes` to manage and exclude specific attributes from Terraform's state management.

---

## Step-01: Introduction

The `lifecycle` meta-argument provides advanced control over how Terraform handles changes to resources. It includes three key arguments:
1. **`create_before_destroy`**: Ensures new resources are created before old ones are destroyed.
2. **`prevent_destroy`**: Prevents Terraform from destroying a resource.
3. **`ignore_changes`**: Excludes specific resource attributes from Terraform's state tracking and reconciliation.

This guide focuses on **`ignore_changes`**, which prevents Terraform from modifying specified attributes even if they are changed manually or updated externally.

---

## Step-02: Review Terraform Manifests

The following manifests are used:
1. **`c1-versions.tf`**: Specifies Terraform and provider versions.
2. **`c2-resource-group.tf`**: Configures the Azure Resource Group.
3. **`c3-virtual-network.tf`**: Configures the Azure Virtual Network.

---

## Step-03: Create an Azure Virtual Network

### Steps:
1. **Switch to the Working Directory:**
   ```bash
   cd terraform-manifests
   ```

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```

3. **Validate Configuration:**
   ```bash
   terraform validate
   ```

4. **Plan and Apply Configuration:**
   ```bash
   terraform plan
   terraform apply -auto-approve
   ```

---

## Step-04: Modify the Resource in the Azure Management Console

### Steps:
1. Manually add a tag to the Azure Virtual Network in the Azure Portal (e.g., `WebServer = Apache`).
2. Run the following commands:
   ```bash
   terraform plan
   terraform apply
   ```

### Observations:
1. Terraform detects the manual changes in the resource state.
2. Terraform will attempt to remove the manually added tag during the `apply` operation.

---

## Step-05: Add the `lifecycle ignore_changes` Block

### Update `c3-virtual-network.tf`:
Add the following `lifecycle` block to the Virtual Network resource:
```hcl
resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  lifecycle {
    ignore_changes = [
      tags, # Ignore changes to tags
    ]
  }
}
```

### Test Ignoring Changes:
1. Add new tags manually in the Azure Management Console (e.g., `WebServer = Apache2` and `ignorechanges = test1`).
2. Run the following commands:
   ```bash
   terraform plan
   terraform apply -auto-approve
   ```

### Observations:
1. Manual changes to tags are ignored by Terraform.
2. Verify in the Azure Portal that the manually added tags remain intact.

---

## Step-06: Understand the Downsides of `ignore_changes`

### Test Adding Tags via Terraform:
1. Add a new tag (e.g., `Env = Dev`) to the Virtual Network resource in `c3-virtual-network.tf`.
2. Run the following commands:
   ```bash
   terraform plan
   terraform apply
   ```

### Observations:
1. Terraform will report **"No changes"** because the `tags` attribute is ignored in the `lifecycle` block.
2. The new tag defined in the configuration will not be applied.

### Key Takeaway:
- While `ignore_changes` protects manual changes, it also prevents Terraform from updating the excluded attributes through configuration.

---

## Step-07: Clean-Up

### Steps:
1. Destroy all resources:
   ```bash
   terraform destroy -auto-approve
   ```

2. Clean up Terraform files:
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   ```

---

## Best Practices

- Use `ignore_changes` sparingly for attributes managed externally (e.g., by other systems or teams).
- Document the reason for excluding attributes to avoid confusion.
- Avoid using `ignore_changes` for critical configuration attributes.

---

## References

- [Terraform Lifecycle Meta-Argument: ignore_changes](https://www.terraform.io/docs/language/meta-arguments/lifecycle.html)
