output "instrumentation_key" {
  description = "The Instrumentation Key for Application Insights."
  value       = azurerm_application_insights.app_insights.instrumentation_key
  sensitive   = true
}

output "connection_string" {
  description = "The Connection String for Application Insights."
  value       = azurerm_application_insights.app_insights.connection_string
  sensitive   = true
}

output "app_insights_id" {
  description = "The ID of the Application Insights instance."
  value       = azurerm_application_insights.app_insights.id
}

output "workspace_id" {
  description = "The ID of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.workspace.id
}
