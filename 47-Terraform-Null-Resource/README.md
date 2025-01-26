# Terraform Null Resource

**Description:** Learn how to use Terraform's Null Resource to create custom triggers for executing provisioners. Additionally, learn how to use the `time` provider to introduce delays for dependent resources.

---

## Step-01: Introduction

### Key Concepts:
1. **Null Provider:**
   - [Null Provider Documentation](https://registry.terraform.io/providers/hashicorp/null/latest/docs).
   - Allows defining resources that execute provisioners without managing infrastructure.
2. **Time Provider:**
   - [Time Provider Documentation](https://registry.terraform.io/providers/hashicorp/time/latest/docs).
   - Enables resource delays, useful for ensuring dependencies are ready.
3. **Null Resource:**
   - [Null Resource Documentation](https://www.terraform.io/docs/language/resources/provisioners/null_resource.html).
   - Helps trigger actions using provisioners and custom triggers.

### Use Case:
- Use a `time_sleep` resource to wait 90 seconds after an Azure VM instance is created.
- Use a `null_resource` with:
  - **File Provisioner:** Copy the `apps/app1` folder to `/tmp`.
  - **Remote Exec Provisioner:** Copy the folder from `/tmp` to `/var/www/html`.

---

## Step-02: Define Providers in Terraform Settings

### Update `c1-versions.tf`:
#### Add Null Provider:
```hcl
    null = {
      source = "hashicorp/null"
      version = ">= 3.0.0"
    }
```

#### Add Time Provider:
```hcl
    time = {
      source = "hashicorp/time"
      version = ">= 0.6.0"
    }  
```

---

## Step-03: Configuration for Time Sleep and Null Resource

### 1. Time Sleep Resource:
- Introduces a 90-second delay after VM creation to ensure Apache Webserver is ready.
```hcl
resource "time_sleep" "wait_90_seconds" {
  depends_on = [azurerm_linux_virtual_machine.mylinuxvm]
  create_duration = "90s"
}
```

### 2. Null Resource with Triggers:
- Executes provisioners every time the `null_resource` is triggered.
- Uses `timestamp()` to force updates on every `terraform apply`.
```hcl
resource "null_resource" "sync_app1_static" {
  depends_on = [time_sleep.wait_90_seconds]
  triggers = {
    always-update = timestamp()
  }

  connection {
    type        = "ssh"
    host        = azurerm_linux_virtual_machine.mylinuxvm.public_ip_address
    user        = azurerm_linux_virtual_machine.mylinuxvm.admin_username
    private_key = file("${path.module}/ssh-keys/terraform-azure.pem")
  }

  # File Provisioner: Copy app1 folder to /tmp
  provisioner "file" {
    source      = "apps/app1"
    destination = "/tmp"
  }

  # Remote Exec Provisioner: Move folder to Apache Webserver directory
  provisioner "remote-exec" {
    inline = [
      "sudo cp -r /tmp/app1 /var/www/html"
    ]
  }
}
```

---

## Step-04: Execute Terraform Commands

### Steps:
1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **Validate Configuration:**
   ```bash
   terraform validate
   ```

3. **Plan Terraform Execution:**
   ```bash
   terraform plan
   ```

4. **Apply Configuration:**
   ```bash
   terraform apply -auto-approve
   ```

### Verification:
1. **Access the VM:**
   ```bash
   ssh -i ssh-keys/terraform-azure.pem azureuser@<PUBLIC-IP>
   ```

2. **Verify Files:**
   - `/tmp/app1` folder and contents.
     ```bash
     ls -lrt /tmp/app1
     ```
   - `/var/www/html/app1` folder and contents.
     ```bash
     ls -lrt /var/www/html/app1
     ```
   - Access via browser:
     ```plaintext
     http://<PUBLIC-IP>/app1/app1-file1.html
     ```

---

## Step-05: Modify Content and Reapply

### Steps:
1. **Modify Files:**
   - Add `app1-file3.html` in `apps/app1/`.
   - Update `app1-file1.html` content.

2. **Terraform Commands:**
   ```bash
   terraform plan
   terraform apply -auto-approve
   ```

3. **Verification:**
   - Check updated files in `/tmp/app1` and `/var/www/html/app1` on the VM.
   - Confirm changes are reflected in the browser:
     ```plaintext
     http://<PUBLIC-IP>/app1/app1-file3.html
     ```

---

## Step-06: Clean-Up

### Steps:
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

## Step-07: Roll Back Changes for Demo

1. **Revert `app1-file1.html` to original content.**
2. **Remove `app1-file3.html`.**

---

## References

1. [Terraform Null Provider](https://registry.terraform.io/providers/hashicorp/null/latest/docs)
2. [Resource: time_sleep](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep)
3. [Terraform Triggers](https://www.terraform.io/docs/language/resources/provisioners/null_resource.html#triggers)

---
