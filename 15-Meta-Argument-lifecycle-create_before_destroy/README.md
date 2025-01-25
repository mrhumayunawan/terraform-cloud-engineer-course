# Terraform Meta-Argument `lifecycle create_before_destroy`

**Description:** Learn how to use the Terraform resource `lifecycle` meta-argument `create_before_destroy` to control the sequence of resource creation and destruction during updates.

---

## Step-01: Introduction

The `lifecycle` meta-argument provides control over how Terraform manages resources during changes. It includes three key options:
1. **`create_before_destroy`**: Ensures new resources are created before old ones are destroyed.
2. **`prevent_destroy`**: Prevents resources from being destroyed.
3. **`ignore_changes`**: Ignores specific changes to a resource.

This guide focuses on implementing and understanding **`create_before_destroy`**.

---

## Step-02: Review Terraform Manifests

The following manifests are required:
1. **`c1-versions.tf`**: Specifies the Terraform and provider versions.
2. **`c2-resource-group.tf`**: Configures the Azure Resource Group.
3. **`c3-virtual-network.tf`**: Configures the Azure Virtual Network.

---

## Step-03: `lifecycle` - `create_before_destroy`

### **Default Behavior:**
- Terraform destroys the existing resource before creating a replacement when changes occur.
  
### **With `create_before_destroy`:**
- The new resource is created **first**, and the old resource is destroyed **afterward**.

### **How to Add Lifecycle Block:**
Include the `lifecycle` block in the resource configuration:
```hcl
resource "azurerm_virtual_network" "myvnet" {
  name                = "myvnet-1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.myrg.location
  resource_group_name = azurerm_resource_group.myrg.name

  lifecycle {
    create_before_destroy = true
  }
}
```

---

## Step-04: Observe Default Behavior (Without Lifecycle Block)

### Steps:
1. **Run Initial Setup:**
   ```bash
   cd terraform-manifests

   terraform init
   terraform validate
   terraform fmt
   terraform plan
   terraform apply -auto-approve
   ```

2. **Modify Configuration:**
   Change the virtual network name in `c3-virtual-network.tf` from `myvnet-1` to `myvnet-2`.

3. **Apply Changes:**
   ```bash
   terraform apply -auto-approve
   ```

### Observation:
1. Terraform will first **destroy** `myvnet-1`.
2. After destruction, Terraform will **create** `myvnet-2`.

---

## Step-05: Observe Behavior With Lifecycle Block

### Steps:
1. **Add Lifecycle Block:**
   Update the `azurerm_virtual_network` resource in `c3-virtual-network.tf` to include the `lifecycle` block:
   ```hcl
   lifecycle {
     create_before_destroy = true
   }
   ```

2. **Generate Plan and Apply Changes:**
   ```bash
   terraform plan
   terraform apply -auto-approve
   ```

3. **Modify Configuration:**
   Change the virtual network name back from `myvnet-2` to `myvnet-1`.

4. **Apply Changes Again:**
   ```bash
   terraform apply -auto-approve
   ```

### Observation:
1. Terraform will first **create** the new resource (`myvnet-1`).
2. After successful creation, Terraform will **destroy** the old resource (`myvnet-2`).

---

## Step-06: Clean-Up Resources

### Steps:
1. Destroy resources:
   ```bash
   terraform destroy -auto-approve
   ```

2. Remove Terraform files:
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   ```

---

## Summary

- **Default Behavior:** Resources are destroyed before replacements are created.
- **With `create_before_destroy`:** Resources are created before replacements are destroyed, ensuring minimal disruption.
- **Use Cases:** Highly recommended for resources where downtime is not acceptable, such as databases or production infrastructure.

---

## References
- [Terraform Resource Meta-Argument: Lifecycle](https://www.terraform.io/docs/language/meta-arguments/lifecycle.html)
