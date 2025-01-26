# Migrate State to Terraform Cloud

**Description:** Learn how to migrate Terraform state from a local backend to Terraform Cloud for better management and collaboration.

---

## Step-01: Introduction

### Key Points:
- We will migrate the state from a local backend to **Terraform Cloud**.
- The goal is to leverage Terraform Cloud’s state management features to enhance collaboration and automation.

---

## Step-02: Review Terraform Manifests

The following Terraform files are part of the configuration:

1. `c1-versions.tf`
2. `c2-variables.tf`
3. `c3-static-website.tf`
4. `c4-outputs.tf`

---

## Step-03: Execute Terraform Commands (First Provision Using Local Backend)

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **Validate Configuration:**
   ```bash
   terraform validate
   ```

3. **Plan the Changes:**
   ```bash
   terraform plan
   ```

4. **Apply the Configuration:**
   ```bash
   terraform apply -auto-approve
   ```

5. **Upload Static Content:**
   - Go to **Storage Accounts** -> `staticwebsitexxxxxx` -> **Containers** -> **$web**.
   - Upload files from the `static-content` folder.

6. **Verify:**
   - Ensure **Azure Storage Account** is created.
   - Verify **Static Website Setting** is enabled.
   - Confirm **Static Content** upload is successful.
   - Access the Static Website via the URL:
     `https://staticwebsitek123.z13.web.core.windows.net/`.

---

## Step-04: Review Your Local State File

Review the local `terraform.tfstate` file that was generated during the first provision. This file contains the current state of your infrastructure.

---

## Step-05: Update Remote Backend in `c1-versions.tf` Terraform Block

Add or update the `backend` block to point to Terraform Cloud:

```hcl
# Template
backend "remote" {
  hostname      = "app.terraform.io"
  organization  = "<YOUR-ORG-NAME>"

  workspaces {
    name = "<SOME-NAME>"
  }
}

# Replace Values
backend "remote" {
  hostname      = "app.terraform.io"
  organization  = "hcta-azure-demo1"  # Your Terraform Cloud Organization

  workspaces {
    name = "state-migration-demo1"
    # Two cases:
    # Case-1: If the workspace already exists, it should not have any state files in the states tab.
    # Case-2: If the workspace does not exist, it will be created during migration.
  }
}
```

---

## Step-06: Migrate State File to Terraform Cloud and Verify

1. **Terraform Login:**
   ```bash
   terraform login
   ```

   **Observation:**
   - You should see the message: `Success! Terraform has obtained and saved an API token.`
   - Verify the **Terraform credentials file**:

   ```bash
   cat /Users/<YOUR_USER>/.terraform.d/credentials.tfrc.json
   ```

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```

   **Observation:**
   - During reinitialization, Terraform prompts if you want to copy the state to the new backend. Enter `yes` to copy the state from your local machine to Terraform Cloud.

   **Sample Output:**
   ```bash
   Initializing the backend...
   Acquiring state lock. This may take a few moments...
   Do you want to copy existing state to the new backend?
     Pre-existing state was found while migrating the previous "local" backend to the
     newly configured "remote" backend. No existing state was found in the newly
     configured "remote" backend. Do you want to copy this state to the new "remote"
     backend? Enter "yes" to copy and "no" to start with an empty state.
   Enter a value: yes
   Successfully configured the backend "remote"! Terraform will automatically
   use this backend unless the backend configuration changes.
   ```

3. **Verify in Terraform Cloud:**
   - A new workspace named **`state-migration-demo1`** should be created.
   - Review the **States** tab in the workspace to confirm that the state file has been migrated.

---

## Step-07: Terraform Cloud to Authenticate to Azure Using Service Principal with a Client Secret

1. **Azure CLI Login:**
   ```bash
   az login
   ```

2. **List Azure Accounts:**
   ```bash
   az account list
   ```

   **Observation:**
   - Make a note of the `subscription_id` (the value of the `"id"` key).

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

5. **Login Using Service Principal:**
   ```bash
   az login --service-principal -u CLIENT_ID -p CLIENT_SECRET --tenant TENANT_ID
   ```

6. **Verify Subscription:**
   ```bash
   az account list-locations -o table
   ```

---

## Step-08: Configure Environment Variables in Terraform Cloud

1. Go to **Organization** -> `hcta-azure-demo1` -> **Workspace** -> `state-migration-demo1` -> **Variables**.
2. Add the following environment variables:

```bash
ARM_CLIENT_ID="00000000-0000-0000-0000-000000000000"
ARM_CLIENT_SECRET="00000000-0000-0000-0000-000000000000"
ARM_SUBSCRIPTION_ID="00000000-0000-0000-0000-000000000000"
ARM_TENANT_ID="00000000-0000-0000-0000-000000000000"
```

---

## Step-09: Delete Local `terraform.tfstate`

1. **Backup the local state file** before deletion:
   ```bash
   cp terraform.tfstate terraform.tfstate_local
   ```

2. **Delete the Local State File:**
   ```bash
   rm terraform.tfstate
   ```

---

## Step-10: Apply a New Run from Terraform CLI

1. Add a new resource (e.g., a new **Resource Group**) in `c3-static-website.tf`.

```hcl
# Create New Resource Group
resource "azurerm_resource_group" "resource_group2" {
  name     = "myrg2021"
  location = "eastus"
}
```

2. **Terraform Plan:**
   ```bash
   terraform plan
   ```

3. **Terraform Apply:**
   ```bash
   terraform apply
   ```

4. **Verify in Terraform Cloud:**
   - Review the **Runs** tab in **Terraform Cloud**.
   - Verify the **States** tab to confirm that the new resource was successfully applied.

---

## Step-11: Destroy & Clean-Up

1. **Destroy Resources from Terraform Cloud:**
   - Go to **Organization** -> `hcta-azure-demo1` -> **Workspace** -> `state-migration-demo1` -> **Settings** -> **Destruction and Deletion**.
   - Click on **Queue Destroy Plan**.

2. **Clean Up Files:**
   ```bash
   rm -rf .terraform*
   rm -rf terraform.tfstate*
   ```

---

## Step-12: Rollback Changes for Seamless Demo

1. **Rollback `c1-versions.tf`:**
   - Comment out the `backend` block (which will be enabled during Step-05).

2. **Rollback `c3-static-website.tf`:**
   - Comment out the **new Resource Group resource** block (which will be enabled during Step-09).

---
