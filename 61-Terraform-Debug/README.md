# Terraform Debug

**Description:** Learn how to use **Terraform Debug** features to troubleshoot and gain insights into the execution process of your Terraform configurations.

---

## Step-01: Introduction

### Key Points:
- **Terraform Debugging** helps you to monitor and understand what happens during the execution of Terraform commands.
- Use **TF_LOG** and **TF_LOG_PATH** environment variables to control the verbosity of Terraform logs.
- **TF_LOG** allows you to set different log levels that determine the amount of detail in the logs:
  - **TRACE**: Provides very detailed verbosity and shows every step taken by Terraform. This generates large outputs with internal logs.
  - **DEBUG**: Offers a more concise version of internal events, but still provides ample information.
  - **ERROR**: Displays errors that stop Terraform from continuing.
  - **WARN**: Logs warnings that might indicate misconfigurations, though they do not prevent execution.
  - **INFO**: Shows high-level, general messages about the execution process.

### Important Note:
- These logs can be helpful for debugging and understanding the internal operations of Terraform, especially when things go wrong.

---

## Step-02: Setup Trace Logging in Terraform

To start logging at the **TRACE** level, follow these steps:

```bash
# Set Terraform Trace Log Settings
export TF_LOG=TRACE
export TF_LOG_PATH="terraform-trace.log"
echo $TF_LOG
echo $TF_LOG_PATH

# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply -auto-approve

# Terraform Destroy
terraform destroy -auto-approve

# Clean-Up
rm -rf .terraform*
rm -rf terraform.tfstate*
rm terraform-trace.log
```

---

## Step-03: Setup These Environment Variables Permanently on Your Desktop

### For Linux Bash

1. Open your **`.bashrc`** file, located in your home directory:
   ```bash
   cd $HOME
   vi .bashrc
   ```

2. Add the following lines to enable Terraform logging:
   ```bash
   # Terraform log settings
   export TF_LOG=TRACE
   export TF_LOG_PATH="terraform-trace.log"
   ```

3. After saving, verify the settings by opening a new terminal:
   ```bash
   echo $TF_LOG
   TRACE
   echo $TF_LOG_PATH
   terraform-trace.log
   ```

### For Windows PowerShell

1. Open your PowerShell profile (`$profile`) by running the following command:
   ```bash
   notepad $profile
   ```

2. Add the following lines to enable Terraform logging in the profile:
   ```powershell
   # Windows Powershell - Terraform log settings
   $env:TF_LOG="TRACE"
   $env:TF_LOG_PATH="terraform.txt"
   ```

3. After saving the file, restart PowerShell and verify the environment variables:
   ```bash
   echo $env:TF_LOG
   TRACE
   echo $env:TF_LOG_PATH
   terraform.txt
   ```

### For macOS

1. Open your **`.bash_profile`** file:
   ```bash
   cd $HOME
   vi .bash_profile
   ```

2. Add the following lines:
   ```bash
   # Terraform log settings
   export TF_LOG=TRACE
   export TF_LOG_PATH="terraform-trace.log"
   ```

3. Save the file, and verify the settings by opening a new terminal:
   ```bash
   echo $TF_LOG
   TRACE
   echo $TF_LOG_PATH
   terraform-trace.log
   ```

---

## Step-04: Terraform Crash Log

- If Terraform crashes (a "panic" in the Go runtime), it creates a **crash log** (`crash.log`) in the working directory.
- The crash log includes debug logs from the session, along with the panic message and backtrace, which can help developers identify the root cause.
- As a user, you're not required to read the crash log, but you can pass it to the developers for troubleshooting.
- To understand how to read a crash log, refer to the official documentation on **[How to read a crash log](https://www.terraform.io/docs/internals/debugging.html#interpreting-a-crash-log)**.

---
