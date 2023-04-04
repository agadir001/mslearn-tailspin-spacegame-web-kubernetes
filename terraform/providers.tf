terraform {
  required_version = ">=1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
        resource_group_name  = "storacc-rg"
        storage_account_name = "storaccxyz001"
        container_name       = "tfstate"
        key                  = "__storagekey__"
    }
}

provider "azurerm" {
  features {}
}
