# Terraform Input Variables CLI Argument `-var`

**Description:** Learn how to override default Terraform input variable values using the `-var` CLI argument. Additionally, understand how to generate and apply Terraform plans.

---

## Step-01: Introduction

- Terraform allows you to override default variable values in configuration files using the `-var` argument.
- This approach is useful when you need to dynamically set variable values during runtime without modifying configuration files.

---

## Step-02: Override Default Values with `-var`

### **Steps:**

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

4. **Override Variables Using `-var`:**
   ```bash
   # Example: Override default values during plan and apply
   terraform plan \
     -var="resoure_group_name=demorg" \
     -var="resoure_group_location=westus" \
     -var="virtual_network_name=demovnet" \
     -var="subnet_name=demosubnet"
   
   terraform apply \
     -var="resoure_group_name=demorg" \
     -var="resoure_group_location=westus" \
     -var="virtual_network_name=demovnet" \
     -var="subnet_name=demosubnet"
   ```

### **Observations:**
- The values provided via `-var` take precedence over default values defined in `variables.tf`.
- Terraform uses the new values during resource creation.

---

## Step-03: Generate and Use Terraform Plans with `-var`

### **Steps:**

1. **Generate a Plan File with `-var`:**
   ```bash
   terraform plan \
     -var="resoure_group_name=demorg" \
     -var="resoure_group_location=westus" \
     -var="virtual_network_name=demovnet" \
     -var="subnet_name=demosubnet" \
     -out v1.plan
   ```

2. **Show the Plan File Details:**
   ```bash
   terraform show v1.plan
   ```

3. **Apply the Plan File:**
   ```bash
   terraform apply v1.plan
   ```

### **Benefits of Using a Plan File:**
- Allows you to review changes before applying them.
- Ensures consistency between the planning and applying phases.

---

## Step-04: Clean-Up

### **Steps:**

1. **Destroy Resources:**
   ```bash
   terraform destroy -auto-approve
   ```

2. **Clean Up Terraform Files:**
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   mv v1.plan v1.plan_bkup
   ```

---

## Key Points

- The `-var` argument is ideal for dynamically setting variable values during runtime.
- Generating and using Terraform plans ensures better control and review of resource changes.
- Variable values provided via `-var` override default values in configuration files.

---

## References

- [Terraform Input Variables Documentation](https://www.terraform.io/docs/language/values/variables.html)
