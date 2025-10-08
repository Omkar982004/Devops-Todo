##############################################
# 🧱  Network layer
##############################################

resource "azurerm_virtual_network" "todo_vnet" {
  name                = "todoapp-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "todo_subnet" {
  name                 = "todoapp-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.todo_vnet.name
  address_prefixes     = ["10.0.2.0/23"]
}

##############################################
# 🌐  Container Apps Environment in the VNet
##############################################

resource "azurerm_container_app_environment" "todo_env" {
  name                     = "todoapp-env"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  infrastructure_subnet_id = azurerm_subnet.todo_subnet.id

  # false = public load balancer for the environment,
  # true  = internal-only environment (we’ll keep false since
  # frontend needs public ingress)
  internal_load_balancer_enabled = false
}

##############################################
# 🚀  Backend Container App (Private)
##############################################

resource "azurerm_container_app" "backend" {
  name                         = "todo-backend"
  resource_group_name          = var.resource_group_name
  container_app_environment_id = azurerm_container_app_environment.todo_env.id
  revision_mode                = "Single"
  
  identity {
    type = "SystemAssigned"
  }

   registry {
    server   = "${var.acr_name}.azurecr.io"
    identity = "system"
  }

  template {
    container {
      name   = "backend"
      image  = "${var.acr_name}.azurecr.io/backend:latest"
      cpu    = 0.5
      memory = "1Gi"

      env {
        name  = "MONGO_URI"
        value = var.mongo_uri
      }
      env {
        name  = "PORT"
        value = "5000"
      }
      env {
        name  = "NODE_ENV"
        value = "production"
      }
    }
  }

  ingress {
    external_enabled = false # 👈 internal only
    target_port      = 5000
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

##############################################
# 🌍  Frontend Container App (Public)
##############################################

resource "azurerm_container_app" "frontend" {
  name                         = "todo-frontend"
  resource_group_name          = var.resource_group_name
  container_app_environment_id = azurerm_container_app_environment.todo_env.id
  revision_mode                = "Single"
  
  identity {
    type = "SystemAssigned"
  }

   registry {
    server   = "${var.acr_name}.azurecr.io"
    identity = "system"
  }

  template {
    container {
      name   = "frontend"
      image  = "${var.acr_name}.azurecr.io/frontend:latest"
      cpu    = 0.5
      memory = "1Gi"

      # NGINX proxy will use BACKEND_URL at runtime
      env {
        name  = "BACKEND_URL"
        value = "http://${azurerm_container_app.backend.latest_revision_fqdn}:5000/"
      }

      # Keep /api path for React build compatibility
      env {
        name  = "VITE_API_URL"
        value = "/api"
      }
    }
  }

  ingress {
    external_enabled = true #  public for users
    target_port      = 80
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}


##############################################
# 🔐  Role Assignments (ACR Pull Permissions)
##############################################
resource "azurerm_role_assignment" "backend_acr_pull" {
  principal_id         = azurerm_container_app.backend.identity[0].principal_id
  role_definition_name = "AcrPull"
  scope                = data.azurerm_container_registry.acr.id
  depends_on           = [azurerm_container_app.backend]
}

resource "azurerm_role_assignment" "frontend_acr_pull" {
  principal_id         = azurerm_container_app.frontend.identity[0].principal_id
  role_definition_name = "AcrPull"
  scope                = data.azurerm_container_registry.acr.id
  depends_on           = [azurerm_container_app.frontend]
}

##############################################
# 📤 Outputs
##############################################

output "frontend_url" {
  description = "Public URL of the frontend app"
  value       = "https://${azurerm_container_app.frontend.ingress[0].fqdn}"
}

output "backend_internal_url" {
  description = "Internal FQDN of backend inside the environment"
  value       = azurerm_container_app.backend.latest_revision_fqdn
}
