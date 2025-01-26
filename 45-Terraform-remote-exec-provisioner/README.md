# Terraform `remote-exec` Provisioner

**Description:** Learn how to use Terraform's `remote-exec` provisioner to execute scripts or commands on a remote resource after it is created.

---

## Step-01: Introduction

### Overview:
- The [`remote-exec` provisioner](https://www.terraform.io/docs/language/resources/provisioners/remote-exec.html) is used to execute commands on a remote resource after its creation.
- Use cases:
  - Configure applications on a remote instance.
  - Bootstrap into a cluster.
  - Run configuration management tools.

---

## Step-02: Use Case and Configuration

### Use Case:
1. Copy a file (`file-copy.html`) to the `/tmp` directory using the `file` provisioner.
2. Use the `remote-exec` provisioner to:
   - Copy the file to Apache's webserver static content directory (`/var/www/html`).
   - Access the file via a browser.

### Configuration:
```hcl
# File Provisioner: Copy file to /tmp
provisioner "file" {
  source      = "apps/file-copy.html"
  destination = "/tmp/file-copy.html"
}

# Remote-Exec Provisioner: Move file to Apache Webserver directory
provisioner "remote-exec" {
  inline = [
    "sleep 120",  # Wait for Apache to be provisioned via custom_data
    "sudo cp /tmp/file-copy.html /var/www/html"
  ]
}
```

---

## Step-03: Review Terraform Manifests and Execute Commands

### Commands:
1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **Validate Configuration:**
   ```bash
   terraform validate
   ```

3. **Format Configuration Files:**
   ```bash
   terraform fmt
   ```

4. **Plan Terraform Execution:**
   ```bash
   terraform plan
   ```

5. **Apply Configuration:**
   ```bash
   terraform apply -auto-approve
   ```

### Verification:
1. **Login to Azure VM Instance:**
   ```bash
   ssh -i ssh-keys/terraform-azure.pem azureuser@<PUBLIC_IP_ADDRESS>
   ssh -i ssh-keys/terraform-azure.pem azureuser@54.197.54.126
   ```

2. **Verify Files:**
   - Check `/tmp` for `file-copy.html`:
     ```bash
     ls -l /tmp/file-copy.html
     ```
   - Check `/var/www/html` for `file-copy.html`:
     ```bash
     ls -l /var/www/html/file-copy.html
     ```

3. **Access File via Browser:**
   ```plaintext
   http://<PUBLIC_IP>/file-copy.html
   ```

---

## Step-04: Clean-Up

### Commands:
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
