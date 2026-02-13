output "cosmos_account_id" {
  description = "The ID of the Cosmos DB account."
  value       = azurerm_cosmosdb_account.this.id
}

output "cosmos_account_name" {
  description = "The name of the Cosmos DB account."
  value       = azurerm_cosmosdb_account.this.name
}

output "cosmos_endpoint" {
  description = "The endpoint of the Cosmos DB account."
  value       = azurerm_cosmosdb_account.this.endpoint
}

output "cosmos_primary_key" {
  description = "The primary key of the Cosmos DB account."
  value       = azurerm_cosmosdb_account.this.primary_key
  sensitive   = true
}

output "cosmos_connection_string" {
  description = "The connection string for the Cosmos DB account."
  value       = azurerm_cosmosdb_account.this.primary_sql_connection_string
  sensitive   = true
}

output "database_name" {
  description = "The name of the Cosmos DB database."
  value       = azurerm_cosmosdb_sql_database.database.name
}

output "containers" {
  description = "Map of created Cosmos DB containers."
  value = {
    for key, container in azurerm_cosmosdb_sql_container.containers :
    key => {
      id   = container.id
      name = container.name
    }
  }
}
