# Terraform Input Variables Using Environment Variables

**Description:** Learn how to override Terraform input variable default values using environment variables.

---

## Step-01: Introduction

Terraform provides the ability to set input variable values using environment variables. This approach is particularly useful for automating Terraform workflows and dynamically passing values without modifying configuration files.

---

## Step-02: Override Input Variables with Environment Variables

### Steps:

1. **Set Environment Variables:**
   Use the prefix `TF_VAR_` followed by the variable name to define environment variables for Terraform input variables.

   ```bash
   # Set environment variables
   export TF_VAR_resoure_group_name=rgenv
   export TF_VAR_resoure_group_location=westus2
   export TF_VAR_virtual_network_name=vnetenv
   export TF_VAR_subnet_name=subnetenv

   # Verify the values
   echo $TF_VAR_resoure_group_name, $TF_VAR_resoure_group_location, $TF_VAR_virtual_network_name, $TF_VAR_subnet_name
   ```

2. **Effect on Terraform:**
   - Terraform automatically detects these environment variables during execution.
   - Values from environment variables override default values defined in the configuration files.

---

## Step-03: Execute Terraform Commands

### Steps:

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **Validate Configuration Files:**
   ```bash
   terraform validate
   ```

3. **Format Configuration Files:**
   ```bash
   terraform fmt
   ```

4. **Plan with Environment Variables:**
   ```bash
   terraform plan
   ```

   **Observation:**
   - Terraform uses the values provided via environment variables (`rgenv`, `westus2`, `vnetenv`, `subnetenv`).

5. **Unset Environment Variables After Demo:**
   ```bash
   unset TF_VAR_resoure_group_name
   unset TF_VAR_resoure_group_location
   unset TF_VAR_virtual_network_name
   unset TF_VAR_subnet_name

   # Verify unset variables
   echo $TF_VAR_resoure_group_name, $TF_VAR_resoure_group_location, $TF_VAR_virtual_network_name, $TF_VAR_subnet_name
   ```

---

## Step-04: Clean-Up

### Steps:

1. **Destroy Resources:**
   ```bash
   terraform destroy -auto-approve
   ```

2. **Remove Terraform Files:**
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   ```

---

## Key Points

- Environment variables are a powerful way to dynamically set Terraform input variable values.
- The `TF_VAR_` prefix ensures that Terraform automatically picks up the environment variable values.
- Always unset environment variables after use to avoid unintended overrides in future runs.

---

## References

- [Terraform Input Variables Documentation](https://www.terraform.io/docs/language/values/variables.html)

