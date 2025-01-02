terraform {
  # Specify the minimum required version of Terraform
  required_version = ">= 1.0.0"  

  # Define required providers with their source and version
  required_providers {            
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0" # Recommended for compatibility
    }
  }

  # Configure Terraform state storage in Azure Blob Storage
  backend "azurerm" { 
    resource_group_name   = "terraform-storage-rg"  # Resource group containing the storage account
    storage_account_name  = "terraformstate201"     # Storage account name
    container_name        = "tfstatefiles"          # Blob container for state files
    key                   = "terraform.tfstate"     # File name for the state file
  }  
  
  # (Optional) Enable experimental features
  experiments = [example]  # For advanced use cases, not required for most projects

  # (Optional) Define provider metadata
  provider_meta "my-provider" { 
    hello = "world" # Advanced configuration, typically unnecessary
  }
}

## Key Highlights:

- Required Version: Ensures that your Terraform CLI version is compatible with the configuration.
- Required Providers: Specifies provider details (like azurerm for Azure) and their version constraints.

Backend Configuration:
- Stores Terraform state files in Azure Blob Storage for team collaboration and state management.
- Ensures consistency and security of the state file.
  
Advanced Features (Optional):
- experiments: Experimental features for advanced Terraform use cases.
- provider_meta: Metadata for custom provider configurations (rarely needed).
