terraform {
  backend "azurerm" {
    resource_group_name   = "todoapp-tf-rg"
    storage_account_name  = "todotfstateacct12345"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
