terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "akshronix-insurance-ai"
    storage_account_name = "akshronixinsuranceaidev"
    container_name       = "tfstate"
    key                  = "dev.tfstate"
  }
}

provider "azurerm" {
  features {}

subscription_id = "8cf6da15-cf39-49b0-b38c-6de93497ff68"
}
