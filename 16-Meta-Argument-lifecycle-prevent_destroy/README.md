# Terraform Meta-Argument `lifecycle prevent_destroy`

**Description:** Learn how to use the Terraform resource `lifecycle` meta-argument `prevent_destroy` to safeguard critical infrastructure from accidental deletion.

---

## Step-01: Introduction

The `lifecycle` meta-argument provides additional controls over how Terraform manages resources. It includes three arguments:
1. **`create_before_destroy`**: Ensures new resources are created before old ones are destroyed.
2. **`prevent_destroy`**: Prevents Terraform from destroying the resource unless explicitly removed.
3. **`ignore_changes`**: Ignores specific changes to a resource.

This guide focuses on the **`prevent_destroy`** argument.

---

## Step-02: Review Terraform Manifests

The following manifests are required:
1. **`c1-versions.tf`**: Specifies the Terraform and provider versions.
2. **`c2-resource-group.tf`**: Configures the Azure Resource Group.
3. **`c3-virtual-network.tf`**: Configures the Azure Virtual Network.

---

## Step-03: `lifecycle` - `prevent_destroy`

### **How `prevent_destroy` Works:**
- When `prevent_destroy = true`, Terraform will reject any plan that attempts to destroy the associated resource.
- It is useful for critical resources, such as databases, to avoid accidental deletions.
- **Important Limitation:** If the resource block is removed from the configuration entirely, `prevent_destroy` is also removed, and Terraform will allow the resource to be destroyed.

### **Lifecycle Block Example:**
```hcl
resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  lifecycle {
    prevent_destroy = true
  }
}
```

---

## Step-04: Execute Terraform Commands

### Steps:
1. **Switch to the Working Directory:**
   ```bash
   cd terraform-manifests
   ```

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```

3. **Validate Configuration Files:**
   ```bash
   terraform validate
   ```

4. **Format Configuration Files:**
   ```bash
   terraform fmt
   ```

5. **Generate Terraform Plan:**
   ```bash
   terraform plan
   ```

6. **Apply Configuration:**
   ```bash
   terraform apply -auto-approve
   ```

7. **Attempt to Destroy Resources:**
   ```bash
   terraform destroy
   ```

### Sample Output (On Destroy Attempt):
```log
╷
│ Error: Instance cannot be destroyed
│ 
│   on c3-virtual-network.tf line 2:
│    2: resource "azurerm_virtual_network" "myvnet" {
│ 
│ Resource azurerm_virtual_network.myvnet has lifecycle.prevent_destroy set, but the
│ plan calls for this resource to be destroyed. To avoid this error and continue
│ with the plan, either disable lifecycle.prevent_destroy or reduce the scope of the
│ plan using the -target flag.
╵
```

---

## Step-05: Remove Lifecycle Block to Destroy Resources

### Steps to Allow Destruction:
1. **Comment or Remove the Lifecycle Block:**
   Update the `c3-virtual-network.tf` file and comment out the `lifecycle` block:
   ```hcl
   # lifecycle {
   #   prevent_destroy = true
   # }
   ```

2. **Destroy Resources:**
   ```bash
   terraform destroy
   ```

3. **Clean-Up Files:**
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   ```

---

## Key Observations

- **With `prevent_destroy`:** Terraform prevents resource destruction and provides an error message.
- **Without `prevent_destroy`:** Resources can be destroyed as usual.

---

## Best Practices

- Use `prevent_destroy` **sparingly** to protect critical resources.
- Document resources with `prevent_destroy` in your codebase for team awareness.
- Be cautious: Removing the resource block from the configuration negates the `prevent_destroy` protection.

---

## References

- [Terraform Resource Meta-Argument: Lifecycle](https://www.terraform.io/docs/language/meta-arguments/lifecycle.html)
