# Terraform Foundational Policies using Sentinel

**Description:** Learn how to use **Terraform Foundational Policies** with **Sentinel** to enforce governance and compliance for your infrastructure code.

---

## Step-01: Introduction

### Key Points:
- **Terraform Foundational Policies Library**: This library contains a set of pre-built Sentinel policies that can be used in **Terraform Cloud** to accelerate your adoption of **policy as code**.
- These policies are provided by Terraform to help you implement common governance controls, such as security and compliance checks.
- [**Terraform Foundational Policies Library**](https://github.com/hashicorp/terraform-foundational-policies-library)

---

## Step-02: Review `sentinel.hcl`

1. **CIS Azure Networking Policies**: These are the policies we will use for this demo. They enforce best practices for securing Azure networking.
   - **[CIS Azure Networking Policies](https://github.com/hashicorp/terraform-foundational-policies-library/tree/master/cis/azure/networking)**
2. The folder containing these policies is called **`terraform-sentinel-cis-policies`**.

### Example of Policies Defined in `sentinel.hcl`:

```hcl
policy "azure-cis-6.1-networking-deny-public-rdp-nsg-rules" {
  source = "https://raw.githubusercontent.com/hashicorp/terraform-foundational-policies-library/master/cis/azure/networking/azure-cis-6.1-networking-deny-public-rdp-nsg-rules/azure-cis-6.1-networking-deny-public-rdp-nsg-rules.sentinel"
  enforcement_level = "advisory"
}

policy "azure-cis-6.2-networking-deny-public-ssh-nsg-rules" {
  source = "https://raw.githubusercontent.com/hashicorp/terraform-foundational-policies-library/master/cis/azure/networking/azure-cis-6.2-networking-deny-public-ssh-nsg-rules/azure-cis-6.2-networking-deny-public-ssh-nsg-rules.sentinel"
  enforcement_level = "advisory"
}

policy "azure-cis-6.3-networking-deny-any-sql-database-ingress" {
  source = "https://raw.githubusercontent.com/hashicorp/terraform-foundational-policies-library/master/cis/azure/networking/azure-cis-6.3-networking-deny-any-sql-database-ingress/azure-cis-6.3-networking-deny-any-sql-database-ingress.sentinel"
  enforcement_level = "advisory"
}

policy "azure-cis-6.4-networking-enforce-network-watcher-flow-log-retention-period" {
  source = "https://raw.githubusercontent.com/hashicorp/terraform-foundational-policies-library/master/cis/azure/networking/azure-cis-6.4-networking-enforce-network-watcher-flow-log-retention-period/azure-cis-6.4-networking-enforce-network-watcher-flow-log-retention-period.sentinel"
  enforcement_level = "advisory"
}
```

---

## Step-03: Copy Sentinel CIS Policies to GitHub Repository

1. Copy the folder `terraform-sentinel-cis-policies` to your local GitHub repository `terraform-sentinel-policies-azure`.
2. **Check-In Code to Remote Repository**:

```bash
# GIT Status
git status

# Git Local Commit
git add .
git commit -am "Sentinel CIS Policies Added in new folder"

# Push to Remote Repository
git push

# Verify the same on Remote Repository
https://github.com/stacksimplify/terraform-sentinel-policies-azure.git
```

---

## Step-04: Add New Sentinel Policy Set in Terraform Cloud

1. Go to **Terraform Cloud** -> **Organization** (`hcta-azure-demo1`) -> **Settings** -> **Policy Sets**.
2. Click on **Connect a new Policy Set**.
3. Use the existing VCS connection from the previous section, **`github-terraform-modules`**, which was created using the **OAuth App** concept.
4. **Choose Repository:** `terraform-sentinel-policies-azure.git`.
5. **Name:** `terraform-sentinel-cis-policies`.
6. **Description:** `Terraform Sentinel CIS Policies`.
7. **Policies Path:** `terraform-sentinel-cis-policies`.
8. **Scope of Policies:** Enforced on selected workspaces.
9. **Workspaces:** Select the `terraform-cloud-azure-demo1` workspace.
10. Click on **Connect Policy Set**.

---

## Step-05: Review Our First Terraform Cloud Workspace

1. Go to **Terraform Cloud** -> **Organization** (`hcta-azure-demo1`) -> **Workspace** (`terraform-cloud-azure-demo1`).
2. Queue a Plan: **CIS-Policy-Test-1**.
3. Verify the following:
   - **Plan**: Review the plan generated.
   - **Cost Estimate**: Check the estimated cost of the proposed infrastructure.
   - **Policy Check**: Review which policies passed and which failed.
4. Finally, **Discard the Run** to clean up.

---

## References

- **[Terraform CIS Policies for Azure Networking](https://github.com/hashicorp/terraform-foundational-policies-library/tree/master/cis/azure/networking)**

---

