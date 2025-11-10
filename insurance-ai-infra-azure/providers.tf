terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstateacct123"
    container_name       = "tfstate"
    key                  = "azure-devops.tfstate"
  }
}

provider "azurerm" {
  features {}

subscription_id = "927fddb8-9af9-4841-9ddd-633d0716ce3b"
}
