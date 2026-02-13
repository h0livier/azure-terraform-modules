variable "resource_group_data" {
  description = "The resource group data for Cosmos DB."
  type = object({
    name     = string
    location = string
  })
}

variable "cosmos_account_name" {
  description = "The name of the Cosmos DB account."
  type        = string
}

variable "database_name" {
  description = "The name of the Cosmos DB database."
  type        = string
  default     = "maindb"
}

variable "containers" {
  description = "Map of containers to create in the Cosmos DB database."
  type = map(object({
    name               = string
    partition_key_path = string
  }))
  default = {
    main = {
      name               = "maincontainer"
      partition_key_path = "/id"
    }
  }
}

variable "allowed_origins" {
  description = "List of allowed origins for CORS."
  type        = list(string)
  default     = ["*"]
}

variable "swa_principal_id" {
  description = "The principal ID of the Static Web App managed identity for RBAC access."
  type        = string
  default     = null
}