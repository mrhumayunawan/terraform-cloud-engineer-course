# Terraform `local-exec` Provisioner

**Description:** Learn how to use Terraform's `local-exec` provisioner to execute commands on the machine running Terraform, triggered during resource creation or destruction.

---

## Step-01: Introduction

### Overview:
- The [`local-exec` provisioner](https://www.terraform.io/docs/language/resources/provisioners/local-exec.html) invokes a command or process on the **local machine** running Terraform.
- Use cases:
  - Generate logs or metadata files.
  - Trigger external scripts or processes.

### Key Points:
- Executes commands locally, not on the remote resource.
- Supports both **creation-time** (default) and **destroy-time** provisioners.

---

## Step-02: Use Case and Configuration

### Use Case:
1. **Creation-Time Provisioner:** Outputs the public IP of the created instance into a file (`creation-time.txt`).
2. **Destroy-Time Provisioner:** Logs the destruction time into a file (`destroy-time.txt`).

### Configuration (`c6-linux-virtual-machine.tf`):
```hcl
# Creation-Time Provisioner
provisioner "local-exec" {
  command     = "echo ${azurerm_linux_virtual_machine.mylinuxvm.public_ip_address} >> creation-time.txt"
  working_dir = "local-exec-output-files/"
}

# Destroy-Time Provisioner
provisioner "local-exec" {
  when        = destroy
  command     = "echo Destroy-time provisioner Instance Destroyed at `date` >> destroy-time.txt"
  working_dir = "local-exec-output-files/"
}
```

---

## Step-03: Execute Terraform Commands

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
- Check the `local-exec-output-files/creation-time.txt` file for the public IP of the instance:
  ```bash
  cat local-exec-output-files/creation-time.txt
  ```

---

## Step-04: Clean-Up

### Steps:
1. **Destroy Resources:**
   ```bash
   terraform destroy -auto-approve
   ```

2. **Verification:**
   - Check the `local-exec-output-files/destroy-time.txt` file for the destruction timestamp:
     ```bash
     cat local-exec-output-files/destroy-time.txt
     ```

3. **Remove Local Files:**
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   ```

---
