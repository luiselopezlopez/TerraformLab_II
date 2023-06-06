terraform {
    required_providers {
        azurerm = {
            source  = "hashicorp/azurerm"
            version = ">= 3.9.0"
        }

        random = {
            source  = "hashicorp/random"
            version = ">= 3.1.0"
        }
    }
    required_version = ">= 0.15"
}

provider "azurerm" {
  features {}
}