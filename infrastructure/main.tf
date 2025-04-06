provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_postgresql_flexible_server" "postgres" {
  name                   = "medusa-postgres"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = var.location
  administrator_login    = var.postgres_admin_user
  administrator_password = var.postgres_admin_password
  version                = "13"
  storage_mb             = 5120
  sku_name               = "Standard_D2s_v3"
  backup_retention_days  = 7
  zone                   = "1"
  delegated_subnet_id    = null
  private_dns_zone_id    = null
}

resource "azurerm_postgresql_flexible_server_database" "medusa_db" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.postgres.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "medusa-app-service-plan"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  kind                = "Linux"
  reserved            = true
  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_web_app" "medusa_web_app" {
  name                = "medusa-webapp-${var.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  app_settings = {
    WEBSITE_RUN_FROM_PACKAGE        = "0"
    DOCKER_REGISTRY_SERVER_URL      = "https://${azurerm_container_registry.acr.login_server}"
    DOCKER_REGISTRY_SERVER_USERNAME = azurerm_container_registry.acr.admin_username
    DOCKER_REGISTRY_SERVER_PASSWORD = azurerm_container_registry.acr.admin_password
    WEBSITES_PORT                   = "9000"

    DATABASE_URL  = "postgresql://${var.postgres_admin_user}@${azurerm_postgresql_flexible_server.postgres.name}.postgres.database.azure.com:5432/${var.db_name}?sslmode=require"
    JWT_SECRET    = var.jwt_secret
    COOKIE_SECRET = var.cookie_secret
    ADMIN_CORS    = var.admin_cors
    STORE_CORS    = var.store_cors
  }

  site_config {
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/medusa:latest"
  }
}
