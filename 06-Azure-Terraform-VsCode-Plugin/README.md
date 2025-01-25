# Azure Terraform VSCode Extension

Explore the capabilities of the **Azure Terraform VSCode Extension**, a tool that integrates Terraform functionality seamlessly into Visual Studio Code. This guide provides step-by-step instructions to help you get started and utilize the extension efficiently.

---

## Prerequisite: Configure Azure Cloud Shell

Before you begin, ensure that Azure Cloud Shell is configured and ready to use. Learn more in the [Azure Cloud Shell documentation](https://learn.microsoft.com/en-us/azure/cloud-shell/).

---

## Table of Contents

1. [Introduction](#introduction)
2. [Install Graphviz](#install-graphviz)
3. [Install Node.js](#install-nodejs)
4. [Install the Azure Terraform VSCode Extension](#install-the-azure-terraform-vscode-extension)
5. [Using VSCode with Integrated Terminal](#using-vscode-with-integrated-terminal)
6. [Using VSCode with CloudShell Terminal](#using-vscode-with-cloudshell-terminal)
7. [Clean-Up](#clean-up)
8. [References](#references)

---

## Introduction

For users facing challenges running Terraform on local machines (Windows or macOS), the **Azure Terraform VSCode Extension** enables efficient Terraform management via Azure Cloud Shell. 

Learn more about the extension on the [Visual Studio Marketplace](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azureterraform).

---

## Install Graphviz

To enable Terraform visualization, install Graphviz.

### Steps:
1. Download Graphviz from [Graphviz Official Site](https://graphviz.org/download/).
2. Install using the following command (macOS users):
   ```bash
   brew install graphviz
   ```

---

## Install Node.js

Node.js is required for some Terraform extension features.

### Steps:
1. Download the Node.js installer from [Node.js Official Website](https://nodejs.org/en/).
2. Install the package by following the setup instructions for your operating system.

---

## Install the Azure Terraform VSCode Extension

Install the **Azure Terraform VSCode Extension** to integrate Terraform features directly into your development environment.

- **Extension Link**: [Azure Terraform VSCode Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azureterraform)
- This extension supports both **local execution** (integrated terminal mode) and **remote execution** (Azure Cloud Shell). However, certain features require local dependencies.

### Supported Features:
1. `Azure Terraform: init`
2. `Azure Terraform: plan`
3. `Azure Terraform: apply`
4. `Azure Terraform: validate`
5. `Azure Terraform: refresh`
6. `Azure Terraform: destroy`
7. `Azure Terraform: visualize`
8. `Azure Terraform: push`
9. `Azure Terraform: execute test`

---

## Using VSCode with Integrated Terminal

Use the **Integrated Terminal** in VSCode to execute Terraform commands.

### Configuration:
1. Navigate to **VS Code Settings** → **Extensions** → **Azure Terraform**.
2. Set **Azure Terraform: Terminal** to `Integrated`.

### Steps:
1. Open the folder `06-Azure-Terraform-VsCode-Plugin/terraform-manifests` in a new VSCode window.
2. Run the following commands using the Command Palette (`CMD + SHIFT + P`):
   - `Azure Terraform: init`
   - `Azure Terraform: validate`
   - `Azure Terraform: plan`
   - `Azure Terraform: apply`
   - `Azure Terraform: destroy`
   - `Azure Terraform: visualize`
3. Review the `Terraform Graph` generated.

---

## Using VSCode with CloudShell Terminal

Run Terraform commands in the **CloudShell Terminal** for remote execution.

### Configuration:
1. Create a CloudShell storage account (if accessing CloudShell for the first time).
2. Navigate to **VS Code Settings** → **Extensions** → **Azure Terraform**.
3. Set **Azure Terraform: Terminal** to `CloudShell`.

### Steps:
1. Open the folder `06-Azure-Terraform-VsCode-Plugin/terraform-manifests` in a new VSCode window.
2. Execute the following commands:
   - `Azure Terraform: Push`
   - `Azure Terraform: init`
   - `Azure Terraform: validate`
   - `Azure Terraform: plan`
   - `Azure Terraform: apply`
   - `Azure Terraform: destroy`
3. Modify the file `c1-versions.tf` and test the `Azure Terraform: Push` command:
   - `Azure Terraform: Push`
   - `Azure Terraform: plan`

---

## Clean-Up

After completing your tasks, clean up Terraform-related files if necessary.

### Steps:
```bash
rm -rf .terraform*
rm -rf terraform.tfstate
```

---

## References

- [Azure Terraform VSCode Extension Documentation](https://docs.microsoft.com/en-us/azure/developer/terraform/configure-vs-code-extension-for-terraform)
- [Graphviz Official Site](https://graphviz.org/download/)


