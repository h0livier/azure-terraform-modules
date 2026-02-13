resource "azurerm_log_analytics_workspace" "workspace" {
  name                = var.log_analytics_name
  location            = var.resource_group_data.location
  resource_group_name = var.resource_group_data.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "app_insights" {
  name                = var.app_insights_name
  location            = var.resource_group_data.location
  resource_group_name = var.resource_group_data.name
  workspace_id        = azurerm_log_analytics_workspace.workspace.id
  application_type    = var.application_type
  
  # Limiter l'ingestion quotidienne pour éviter les coûts (5GB/mois ≈ 0.17GB/jour)
  daily_data_cap_in_gb = 0.5
  daily_data_cap_notifications_disabled = false
}
