# Terraform Cloud - CLI-Driven Workflow

**Description:** Learn how to implement the **CLI-Driven Workflow** in **Terraform Cloud**, and manage resources with the Terraform CLI integrated into Terraform Cloud.

---

## Step-01: Introduction

### Key Points:
- Implement the **CLI-Driven Workflow** in **Terraform Cloud**.
- Use the Terraform CLI to manage state, configurations, and executions in Terraform Cloud.

---

## Step-02: Review Terraform Configuration Files

The following configuration files will be used for this demo:

1. `c1-versions.tf`
2. `c2-variables.tf`
3. `c3-static-website.tf`
4. `c4-outputs.tf`

---

## Step-03: Create Workspace with CLI-Driven Workflow

1. Login to **[Terraform Cloud](https://app.terraform.io/)**.
2. Select **Organization** -> `hcta-azure-demo1`.
3. Click on **New Workspace**.
4. **Choose your workflow:** **CLI-Driven Workflow**.
5. **Workspace Name:** `cli-driven-azure-demo`.
6. **Workspace Description:** `Terraform Cloud CLI Driven Workflow Azure Demo`.
7. Click **Create Workspace**.

---

## Step-04: Add Backend Block in Terraform Settings (`c1-versions.tf`)

```hcl
terraform {
  backend "remote" {
    organization = "hcta-azure-demo1"

    workspaces {
      name = "cli-driven-azure-demo"
    }
  }
}
```

---

## Step-05: Verify `c3-static-website.tf`

Modify the `source` of the module to reflect the private module registry:

```hcl
# Before:
  source  = "app.terraform.io/hcta-azure-demo1/staticwebsiteprivate/azurerm"

# After:
  source  = "app.terraform.io/<YOUR_ORGANIZATION>/<YOUR_MODULE_NAME_IF_DIFFERENT>/azurerm"
  source  = "app.terraform.io/<YOUR_ORGANIZATION>/staticwebsitepr/azurerm"   
```

---

## Step-06: Execute Terraform Commands

1. **Terraform Login:**
   ```bash
   terraform login
   ```
   - Token Name: `clidemoapitoken1`
   - Token Value: `your-token-value-here`
   
   **Observation:**
   - You should see the message: `Retrieved token for user <your-username>`.
   - Verify the **Terraform credentials file**:

   ```bash
   cat /Users/<YOUR_USER>/.terraform.d/credentials.tfrc.json
   ```

2. **Terraform Initialize:**
   ```bash
   terraform init
   ```

   **Observation:**
   - Should fail initially due to missing access to the Private Registry in Terraform Cloud.

   **Sample Output:**
   ```bash
   Error: Error accessing remote module registry
   Failed to retrieve available versions for module "azure_static_website": error looking up module versions: 401 Unauthorized.
   ```

3. **Terraform Validate:**
   ```bash
   terraform validate
   ```

4. **Terraform Format:**
   ```bash
   terraform fmt
   ```

5. **Terraform Plan:**
   ```bash
   terraform plan
   ```

   **Observation:**
   - You may see an error like this due to missing Azure provider credentials:

   ```bash
   Error: Error building AzureRM Client: obtain subscription() from Azure CLI: Error parsing json result from the Azure CLI: Error waiting for the Azure CLI: exit status 1: ERROR: Please run 'az login' to setup account.
   ```

---

## Step-07: Terraform Cloud to Authenticate to Azure Using Service Principal with a Client Secret

1. **Azure CLI Login:**
   ```bash
   az login
   ```

2. **Get the Subscription ID:**
   ```bash
   az account list
   ```

   **Observation:**
   - Make a note of the `subscription_id` (value of the key `"id"`).

3. **Set the Subscription ID:**
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

5. **Login using Service Principal:**
   ```bash
   az login --service-principal -u CLIENT_ID -p CLIENT_SECRET --tenant TENANT_ID
   ```

6. **Verify Subscription:**
   ```bash
   az account list-locations -o table
   ```

---

## Step-08: Configure Environment Variables in Terraform Cloud

1. Go to **Organization** -> `hcta-azure-demo1` -> **Workspace** -> `cli-driven-azure-demo` -> **Variables**.
2. Add the following environment variables:

```bash
ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```

---

## Step-09: Execute Terraform Commands

1. **Terraform Plan:**
   ```bash
   terraform plan
   ```

   **Observation:**
   - Open the plan using the link provided in the CLI output.
   - Terraform plan should pass now.

2. **Terraform Apply:**
   ```bash
   terraform apply
   ```

   **Observation:**
   - Go to **Terraform Cloud** -> **Organization** -> `hcta-azure-demo1` -> **Workspace** -> `cli-driven-azure-demo` -> **Runs Tab**.
   - Review the plan and provide confirmation (`yes`) in Terraform CLI.
   - Observe the **Terraform Cloud Runs** tab for execution logs.

3. **Upload Static Content:**
   - Go to **Storage Accounts** -> `staticwebsitexxxxxx` -> **Containers** -> **$web**.
   - Upload files from the `static-content` folder.

4. **Verify:**
   - Verify the **Azure Storage Account** is created.
   - Ensure **Static Website Setting** is enabled.
   - Confirm **Static Content** upload success.
   - Access the **Static Website** via the **Primary Endpoint** URL:
     `https://staticwebsitek123.z13.web.core.windows.net/`.

---

## Step-10: Verify the Following

1. Select **Organization** -> `hcta-azure-demo1`.
2. **Workspace Name:** `cli-driven-azure-demo`.
3. Review the **Runs** and **States**.

   **Key Observation:**
   - The Terraform commands executed on your local machine are run on Terraform Cloud, and you can see the status in the **Runs** tab.
   - The **State** is maintained in Terraform Cloud.

---

## Step-11: Destroy and Clean-Up

1. **Terraform Destroy:**
   ```bash
   terraform destroy
   ```

2. **Delete Terraform Files:**
   ```bash
   rm -rf .terraform*
   ```

---

## Additional References

- [CLI Configuration File](https://www.terraform.io/docs/cli/config/config-file.html#credentials)

---
