variable "static_web_app_name" {
  description = "The name of the Static Web App."
  type        = string
}

variable "resource_group_data" {
    description = "The resource group data for the Static Web App."
    type        = object({
        name     = string
        location = string
    })
}

variable "app_settings" {
    description = "Application settings for the Static Web App backend (Azure Functions)."
    type        = map(string)
    default     = {}
}