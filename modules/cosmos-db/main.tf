resource "azurerm_cosmosdb_account" "this" {
  name                = var.cosmos_account_name
  location            = var.resource_group_data.location
  resource_group_name = var.resource_group_data.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  free_tier_enabled   = true

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.resource_group_data.location
    failover_priority = 0
  }

  is_virtual_network_filter_enabled = false
  
  # Configuration CORS
  cors_rule {
    allowed_origins    = var.allowed_origins
    allowed_methods    = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
    allowed_headers    = ["*"]
    exposed_headers    = ["*"]
    max_age_in_seconds = 3600
  }
}

resource "azurerm_cosmosdb_sql_database" "database" {
  name                = var.database_name
  resource_group_name = var.resource_group_data.name
  account_name        = azurerm_cosmosdb_account.this.name
}

resource "azurerm_cosmosdb_sql_container" "containers" {
  for_each = var.containers

  name                = each.value.name
  resource_group_name = var.resource_group_data.name
  account_name        = azurerm_cosmosdb_account.this.name
  database_name       = azurerm_cosmosdb_sql_database.database.name
  partition_key_paths = [each.value.partition_key_path]
}

# Role Assignment pour donner accès RBAC à la Static Web App
resource "azurerm_cosmosdb_sql_role_assignment" "swa_access" {
  count               = var.swa_principal_id != null ? 1 : 0
  resource_group_name = var.resource_group_data.name
  account_name        = azurerm_cosmosdb_account.this.name
  role_definition_id  = "${azurerm_cosmosdb_account.this.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
  principal_id        = var.swa_principal_id
  scope               = azurerm_cosmosdb_account.this.id
}
