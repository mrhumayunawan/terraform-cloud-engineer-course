# Terraform File Provisioner

**Description:** Learn how to use Terraform's `file` provisioner for copying files to remote resources, understand provisioner behavior, and explore creation-time and destroy-time provisioners.

---

## Step-00: Provisioner Concepts

### Types of Generic Provisioners:
1. [File Provisioner](https://www.terraform.io/docs/language/resources/provisioners/file.html)
2. `local-exec`
3. `remote-exec`

### Provisioner Timings:
- **Creation-Time Provisioners** (default): Execute during resource creation.
- **Destroy-Time Provisioners**: Execute during resource destruction.

### Provisioner Failure Behavior:
- **continue**: Ignore errors and proceed.
- **fail** (default): Raise an error, stop execution, and mark the resource as **tainted**.

### Additional Concepts:
- [Provisioner Connections](https://www.terraform.io/docs/language/resources/provisioners/connection.html)
- **Self Object**: Use `self` for resource attributes within the same resource block.

---

## Pre-requisites: SSH Keys for Azure VM

1. **Create SSH Keys:**
   ```bash
   mkdir ssh-keys
   ssh-keygen -m PEM -t rsa -b 4096 -C "azureuser@myserver" -f ssh-keys/terraform-azure.pem
   chmod 400 ssh-keys/terraform-azure.pem
   ```

2. **Generated Files:**
   - Private Key: `terraform-azure.pem`
   - Public Key: Rename `terraform-azure.pem.pub` to `terraform-azure.pub`.

---

## Step-01: Introduction to File Provisioner

### Overview:
- Copy files to remote resources during creation or destruction.
- Use [Provisioner Connection Block](https://www.terraform.io/docs/language/resources/provisioners/connection.html).

### Sample Connection Block:
```hcl
connection {
  type        = "ssh"
  host        = self.public_ip_address
  user        = self.admin_username
  private_key = file("${path.module}/ssh-keys/terraform-azure.pem")
}
```

---

## Step-02: File Provisioners

### Examples:
```hcl
# File Provisioner-1: Copy file to /tmp
provisioner "file" {
  source      = "apps/file-copy.html"
  destination = "/tmp/file-copy.html"
}

# File Provisioner-2: Copy content as a file
provisioner "file" {
  content     = "VM Host Name: ${self.computer_name}"
  destination = "/tmp/file.log"
}

# File Provisioner-3: Copy a folder
provisioner "file" {
  source      = "apps/app1"
  destination = "/tmp"
}

# File Provisioner-4: Copy folder contents
provisioner "file" {
  source      = "apps/app2/"
  destination = "/tmp"
}
```

---

## Step-03: Execute Terraform Commands

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```
2. **Validate Configuration:**
   ```bash
   terraform validate
   ```
3. **Apply Configuration:**
   ```bash
   terraform apply -auto-approve
   ```

4. **Verify Files on VM:**
   ```bash
   ssh -i ssh-keys/terraform-azure.pem azureuser@<VM-PUBLIC-IP>
   cd /tmp
   ls -l
   ```

---

## Step-04: Handle Provisioner Failure Behavior

### Failure Behavior:
- **Default (`fail`)**: Stops execution and marks the resource as **tainted**.
- **With `on_failure = continue`**: Ignores the error and continues.

### Test Failure Scenarios:
#### Scenario 1: Default Behavior (Fail)
```hcl
provisioner "file" {
  source      = "apps/file-copy.html"
  destination = "/var/www/html/file-copy.html"
}
```

- **Command:**
  ```bash
  terraform apply -auto-approve
  ```
- **Observation:**
  - Terraform fails because `azureuser` lacks permission for `/var/www/html`.

#### Scenario 2: Continue on Failure
```hcl
provisioner "file" {
  source      = "apps/file-copy.html"
  destination = "/var/www/html/file-copy.html"
  on_failure  = "continue"
}
```

- **Command:**
  ```bash
  terraform apply -auto-approve
  ```
- **Observation:**
  - Terraform continues without marking the resource as tainted.

---

## Step-05: Clean-Up

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

## Step-06: Destroy-Time Provisioners

### Overview:
- Execute a provisioner during resource destruction using `when = destroy`.

### Example:
```hcl
resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  # ...

  provisioner "local-exec" {
    when    = destroy
    command = "echo 'Destroy-time provisioner'"
  }
}
```

---

## References

1. [Terraform File Provisioner](https://www.terraform.io/docs/language/resources/provisioners/file.html)
2. [Provisioner Connections](https://www.terraform.io/docs/language/resources/provisioners/connection.html)
3. [Destroy-Time Provisioners](https://www.terraform.io/docs/language/resources/provisioners/syntax.html#destroy-time-provisioners)

---
