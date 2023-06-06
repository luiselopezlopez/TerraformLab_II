terraform {
 backend "azurerm" {
 resource_group_name = "rg-tfstate"
 storage_account_name = "luisetfstorageaccount"
 container_name = "tfstate"
 key = "terraform.tfstate"
 }
}


