variable "resource_group_data" {
  description = "The resource group data for the Linux Web App."
  type = object({
    name     = string
    location = string
  })
}

variable "service_plan_name" {
  description = "The name of the App Service Plan."
  type        = string
}

variable "linux_web_app_name" {
  description = "The name of the Linux Web App."
  type        = string
}

variable "service_plan_sku_name" {
  description = "The SKU name for the App Service Plan (e.g. F1, B1, S1, P1v2)."
  type        = string
  default     = "F1"
}

variable "app_settings" {
  description = "Application settings for the Linux Web App."
  type        = map(string)
  default     = {}
}

variable "application_stack" {
  description = "The application stack configuration for the Linux Web App."
  type = object({
    docker_image_name   = optional(string)
    docker_registry_url = optional(string)
    dotnet_version      = optional(string)
    go_version          = optional(string)
    java_server         = optional(string)
    java_server_version = optional(string)
    java_version        = optional(string)
    node_version        = optional(string)
    php_version         = optional(string)
    python_version      = optional(string)
    ruby_version        = optional(string)
  })
  default = null
}

variable "always_on" {
  description = "Whether the Linux Web App should be always on. Not compatible with F1/D1 SKU."
  type        = bool
  default     = false
}

variable "https_only" {
  description = "Whether the Linux Web App requires HTTPS only."
  type        = bool
  default     = true
}

variable "identity_type" {
  description = "The type of managed identity for the Linux Web App. Accepted values: SystemAssigned, UserAssigned, or both combined."
  type        = string
  default     = "SystemAssigned"
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
