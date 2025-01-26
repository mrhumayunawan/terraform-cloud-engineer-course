# Terraform Cloud and Sentinel Policies

**Description:** Learn how to implement **Terraform Cloud** and **Sentinel Policies** to enforce governance and compliance for your infrastructure code.

---

## Step-01: Introduction

### Key Points:
- **Trial Plan for 30 Days:** Explore **Team & Governance** features of Terraform Cloud, including Sentinel policies.
- **Implement CLI-Driven Workflow:** Provision multiple Azure resources using Terraform Cloud’s CLI-driven workflow:
  1. `azurerm_resource_group`
  2. `azurerm_linux_virtual_machine`
  3. `azurerm_virtual_network`
  4. `azurerm_public_ip`
  5. `azurerm_network_interface`
- **Understand Sentinel Policies:** Learn about the following 5 Sentinel policies:
  1. `allowed-providers.sentinel`
  2. `enforce-mandatory-tags.sentinel`
  3. `limit-proposed-monthly-cost.sentinel`
  4. `restrict-vm-publisher.sentinel`
  5. `restrict-vm-size.sentinel`
- Learn how to define **sentinel.hcl** and create a GitHub repository for Sentinel policies to use them as Policy Sets in Terraform Cloud.
- **Enforcement Levels:** Understand the Sentinel policy enforcement levels:
  1. `advisory`
  2. `soft-mandatory`
  3. `hard-mandatory`

---

## Step-02: Review Terraform Manifests

The following Terraform files are used for this demo:

1. `c1-versions.tf`
2. `c2-variables.tf`
3. `c3-locals.tf`
4. `c4-resource-group.tf`
5. `c5-virtual-network.tf`
6. `c6-linux-virtual-machine.tf`
7. `c7-outputs.tf`
8. `dev.auto.tfvars`

---

## Step-03: Review the Git-Repo-Files-Sentinel

1. Review the **Terraform Governance Guides** for Third Generation (as of today).
   - **[Terraform Governance Guides](https://github.com/hashicorp/terraform-guides/tree/master/governance)**
2. Files:
   - `common-functions` folder
   - `azure-functions` folder
   - `terraform-generic-sentinel-policies`

---

## Step-04: Review 5 Sentinel Policies and `sentinel.hcl`

1. **Allowed Providers Policy** (`allowed-providers.sentinel`)
2. **Enforce Mandatory Tags Policy** (`enforce-mandatory-tags.sentinel`)
3. **Limit Proposed Monthly Cost Policy** (`limit-proposed-monthly-cost.sentinel`)
4. **Restrict VM Publisher Policy** (`restrict-vm-publisher.sentinel`)
5. **Restrict VM Size Policy** (`restrict-vm-size.sentinel`)
6. **sentinel.hcl**: The configuration file to define and manage policies.

---

## Step-05: Create CLI-Driven Workspace on Terraform Cloud

### Step-05-01: Verify Trial Plan in `hcta-azure-demo1` Organization

1. Login to **Terraform Cloud**.
2. Go to **Organizations** -> `hcta-azure-demo1` -> **Settings** -> **Plan & Billing**.
3. Verify the **Current Plan**:
   ```t
   Free Trial
   You are currently trialing Terraform Cloud's premium features, including improved team management, Sentinel policies, and cost estimation.
   ```
   - Your plan will revert to the **Free Plan** after the trial ends.

---

### Step-05-02: Create CLI-Driven Workspace in Organization `hcta-azure-demo1`

1. Login to **[Terraform Cloud](https://app.terraform.io/)**.
2. Select **Organization** -> `hcta-azure-demo1`.
3. Click on **New Workspace**.
4. **Choose your workflow:** **CLI-Driven Workflow**.
5. **Workspace Name:** `sentinel-azure-demo1`.
6. Click on **Create Workspace**.

---

### Step-05-03: Update `c1-versions.tf` with Terraform Backend

In the `c1-versions.tf` file, add the Terraform Cloud backend configuration:

```hcl
# Terraform Backend pointed to TF Cloud
backend "remote" {
  organization = "hcta-azure-demo1-internal"

  workspaces {
    name = "sentinel-azure-demo1"
  }
}
```

---

## Step-06: Terraform Cloud to Authenticate to Azure Using Service Principal with a Client Secret

1. **Azure CLI Login:**
   ```bash
   az login
   ```

2. **Azure Account List:**
   ```bash
   az account list
   ```
   - Make a note of the `subscription_id`.

3. **Set Subscription ID:**
   ```bash
   az account set --subscription="SUBSCRIPTION_ID"
   ```

4. **Create Service Principal & Client Secret:**
   ```bash
   az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"
   ```

   **Sample Output:**
   ```json
   {
     "appId": "99a2bb50-e5a1-4d72-acd3-e4697ecb5308",
     "password": "0ed3ZeK0DijKvhat~a5NnaQ_bpG_uv_-Xh",
     "tenant": "c81f465b-99f9-42d3-a169-8082d61c677a"
   }
   ```

5. **Login Using Service Principal:**
   ```bash
   az login --service-principal -u CLIENT_ID -p CLIENT_SECRET --tenant TENANT_ID
   ```

6. **Verify Subscription:**
   ```bash
   az account list-locations -o table
   ```

---

## Step-07: Configure Environment Variables in Terraform Cloud

1. Go to **Organization** -> `hcta-azure-demo1` -> **Workspace** -> `sentinel-azure-demo1` -> **Variables**.
2. Add the following environment variables:

```bash
ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```

---

## Step-08: Create GitHub Repository for Sentinel Policies (Policy Sets)

### Step-08-01: Create a New GitHub Repository

1. **URL:** [github.com](https://github.com)
2. Click on **Create a new repository**.
3. **Repository Name:** `terraform-sentinel-policies-azure`.
4. **Description:** `Terraform Cloud and Sentinel Policies Demo on Azure`.
5. **Repo Type:** Public / Private.
6. Initialize with:
   - **CHECK**: Add a README file
   - **CHECK**: Add `.gitignore`
   - **Select `.gitignore Template`:** Terraform
   - **CHECK**: Choose a license (optional)
   - **Select License:** Apache 2.0 License.
7. Click **Create repository**.

---

### Step-08-02: Clone GitHub Repository to Local Desktop

```bash
# Clone GitHub Repo
git clone https://github.com/<YOUR_GITHUB_ID>/<YOUR_REPO>.git
git clone https://github.com/stacksimplify/terraform-sentinel-policies.git
```

---

### Step-08-03: Copy Files from `terraform-sentinel-policies` Folder to Local Repo & Check-In Code

1. **Source Location:** Git-Repo-Files-Sentinel
2. **Destination Location:** Copy all files and folders from `Git-Repo-Files-Sentinel` to your cloned GitHub repository folder `terraform-sentinel-policies-azure`.

### Check-In Code to Remote Repository:

```bash
# GIT Status
git status

# Git Local Commit
git add .
git commit -am "Sentinel Policies First Commit"

# Push to Remote Repository
git push

# Verify on Remote Repository
https://github.com/stacksimplify/terraform-sentinel-policies-azure.git
```

---

## Step-09: Create Policy Sets in Terraform Cloud

1. Go to **Terraform Cloud** -> **Organization** -> `hcta-azure-demo1` -> **Settings** -> **Policy Sets**.
2. Click on **Connect a new Policy Set**.
3. Select **Existing VCS connection** (from the previous section, `github-terraform-modules`).
4. **Choose Repository:** `terraform-sentinel-policies-azure.git`.
5. **Description:** `Demo Sentinel Policies`.
6. **Policies Path:** `terraform-generic-sentinel-policies`.
7. **Scope of Policies:** Enforced on selected workspaces.
8. **Workspaces:** Select `sentinel-azure-demo1`.
9. Click **Connect Policy Set**.

---

## Step-10: Execute Terraform Commands

1. **Terraform Login:**
   ```bash
   terraform login
   ```

2. **Terraform Initialize:**
   ```bash
   terraform init
   ```

3. **Terraform Apply:**
   ```bash
   terraform apply
   ```

   **Observation:**
   - Verify **Sentinel Policies** in **Terraform Cloud**.
   - Ensure the **Sentinel Enforcement Mode** is set to `advisory` for `limit-proposed-monthly-cost`.
   - All policies should pass, and you should proceed to the next steps.

---

## Step-11: Verify Sentinel Enforcement Mode (`soft-mandatory`)

1. Update the **enforcement level** for `limit-proposed-monthly-cost` to `soft-mandatory` in `sentinel.hcl`.

2. **Commit and Push Changes:**
   ```bash
   git status
   git add .
   git commit -am "soft-mandatory Commit"
   git push
   ```

3. **Terraform Apply:**
   ```bash
   terraform apply
   ```

4. **Observation:**
   - The policy check should fail, but you will have the option to override and continue.

---

## Step-12: Verify Sentinel Enforcement Mode (`hard-mandatory`)

1. Update the **enforcement level** for `limit-proposed-monthly-cost` to `hard-mandatory` in `sentinel.hcl`.

2. **Commit and Push Changes:**
   ```bash
   git status
   git add .
   git commit -am "hard-mandatory Commit"
   git push
   ```

3. **Terraform Apply:**
   ```bash
  

 terraform apply
   ```

4. **Observation:**
   - The policy check will fail, and **Terraform Execution** will stop there with no option to continue or override.

---

## Step-13: Clean-Up & Destroy

1. **Terraform Destroy:**
   ```bash
   terraform destroy -auto-approve
   ```

2. **Clean-Up Files:**
   ```bash
   rm -rf .terraform*
   ```

3. **Rollback in Repo:**
   - Rollback the enforcement level of `limit-proposed-monthly-cost` to `advisory`.

4. **Commit and Push Changes:**
   ```bash
   git status
   git add .
   git commit -am "Rollback to advisory"
   git push
   ```

---

## Step-14: Roll Back Changes for Seamless Demo

```hcl
policy "limit-proposed-monthly-cost" {
    source = "./limit-proposed-monthly-cost.sentinel"
    enforcement_level = "advisory"
}
```

---

## References:
- [Terraform & Sentinel](https://www.terraform.io/docs/cloud/sentinel/index.html)
- [Sentinel Policy Examples](https://www.terraform.io/docs/cloud/sentinel/examples.html)
- [Sentinel Enforcement Levels](https://docs.hashicorp.com/sentinel/concepts/enforcement-levels)

---
