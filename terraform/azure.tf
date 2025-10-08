##############################################
# 📘 Terraform backend (state in Azure)
##############################################

terraform {
  backend "azurerm" {
    resource_group_name  = "todoapp-tf-rg"
    storage_account_name = "todotfstateacct12345"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

##############################################
# ☁️ Azure provider
##############################################

provider "azurerm" {
  features {}
  subscription_id = "1bd02d46-ab8a-499a-90cd-ac024b810671"

}

##############################################
# 🧱 Resource group reference
##############################################

data "azurerm_resource_group" "todo_rg" {
  name = var.resource_group_name
}

##############################################
# 🐳 Container Registry (ACR reference)
##############################################

data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = data.azurerm_resource_group.todo_rg.name
}

##############################################
# 📤 Useful outputs
##############################################

output "acr_login_server" {
  description = "ACR login server for pulling images"
  value       = data.azurerm_container_registry.acr.login_server
}
