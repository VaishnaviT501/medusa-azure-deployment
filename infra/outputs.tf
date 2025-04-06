output "webapp_url" {
  value = azurerm_web_app.medusa_web_app.default_hostname
}

output "postgres_fqdn" {
  value = azurerm_postgresql_flexible_server.postgres.fqdn
}

output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}
