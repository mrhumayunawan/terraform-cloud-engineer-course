# Terraform External Provider and Datasource

**Description:** Learn how to use the **Terraform External Provider** and **Datasource** to integrate external data and use it in Terraform configurations, including integrating it with Azure Virtual Machine resources.

---

## Step-01: Introduction

### Key Points:
- **[Terraform External Provider and Datasource](https://registry.terraform.io/providers/hashicorp/external/latest)** allow you to run external scripts and interact with data sources outside Terraform’s native capabilities.
- In the previous demo, we learned how to use external providers and datasources. Here, we will integrate this with **Azure Virtual Machine** Terraform resources.
  
---

## Step-02: Review Terraform Configs

The following files were copied from the **`11-01-Terraform-Azure-Linux-Virtual-Machine`** setup:

1. `c1-versions.tf`
2. `c2-resource-group.tf`
3. `c3-virtual-network.tf`
4. `c4-linux-virtual-machine.tf`
5. `c5-external-datasource.tf`
6. `app-scripts/app1-cloud-init.txt`
7. `shell-scripts/ssh_key_generator.sh`

---

## Step-03: `c4-linux-virtual-machine.tf`

In this step, we will change the **`public_key`** argument for **admin_ssh_key** to use the value fetched from the **External Datasource**.

```hcl
# Before
admin_ssh_key {
  username   = "azureuser"
  public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
}

# After
admin_ssh_key {
  username   = "azureuser"
  public_key = data.external.ssh_key_generator.result.public_key
}
```

---

## Step-04: Execute Terraform Commands

Run Terraform commands to apply the configuration and observe the results.

```bash
# Terraform Initialize
terraform init

# Terraform Validate
terraform validate

# Terraform Plan
terraform plan

# Observation:
# 1. Since it's just a datasource, the `ssh_key_generator.sh` script will be triggered by Terraform during `terraform plan` or `terraform apply`.
# 2. Public and Private Keys will be generated and available for the Azure VM configuration.

# Terraform Apply
terraform apply -auto-approve

# Connect to the Azure VM (should be successful)
chmod 400 shell-scripts/terraformdemo-dev
ssh -i shell-scripts/terraformdemo-dev azureuser@<PUBLIC-IP-OF-VM>

# Access the Sample App
http://<PUBLIC-IP-OF-VM>
```

---

## Step-05: Clean-Up

After completing the steps, destroy the resources and clean up the environment.

```bash
# Destroy Resources
terraform destroy -auto-approve 

# Delete Files
rm -rf .terraform* 
rm -rf terraform.tfstate*
```

--- 
