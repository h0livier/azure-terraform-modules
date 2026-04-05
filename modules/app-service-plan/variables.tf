variable "resource_group_data" {
  description = "The resource group data for the App Service Plan."
  type = object({
    name     = string
    location = string
  })
}

variable "app_service_plan_name" {
  description = "The name of the App Service Plan."
  type        = string
}

variable "os_type" {
  description = "The OS type for the App Service Plan. Accepted values: Linux, Windows, WindowsContainer."
  type        = string
  default     = "Linux"
}

variable "sku_name" {
  description = "The SKU name for the App Service Plan (e.g. F1, B1, S1, P1v2, P1v3)."
  type        = string
  default     = "F1"
}

variable "worker_count" {
  description = "The number of workers (instances) to allocate for the App Service Plan. Defaults to null, which uses Azure's default worker count for the selected SKU."
  type        = number
  default     = null
}

variable "zone_balancing_enabled" {
  description = "Whether zone balancing is enabled for the App Service Plan. When enabled, ensure a Premium SKU and at least 3 workers are configured."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the App Service Plan."
  type        = map(string)
  default     = {}
}
