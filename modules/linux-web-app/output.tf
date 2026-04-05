output "linux_web_app_id" {
  description = "The ID of the Linux Web App."
  value       = azurerm_linux_web_app.this.id
}

output "linux_web_app_name" {
  description = "The name of the Linux Web App."
  value       = azurerm_linux_web_app.this.name
}

output "default_hostname" {
  description = "The default hostname of the Linux Web App."
  value       = azurerm_linux_web_app.this.default_hostname
}

output "principal_id" {
  description = "The principal ID of the Linux Web App managed identity."
  value       = azurerm_linux_web_app.this.identity[0].principal_id
}

output "tenant_id" {
  description = "The tenant ID of the Linux Web App managed identity."
  value       = azurerm_linux_web_app.this.identity[0].tenant_id
}

output "service_plan_id" {
  description = "The ID of the App Service Plan."
  value       = azurerm_service_plan.this.id
}
