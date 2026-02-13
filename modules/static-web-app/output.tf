output "static_web_app_url" {
  description = "The default hostname of the static web app"
  value       = azurerm_static_web_app.this.default_host_name
}

# Output the Static Web App deployment token (sensitive)
output "deployment_token" {
  description = "The deployment token for GitHub Actions"
  value       = azurerm_static_web_app.this.api_key
  sensitive   = true
}