variable "resource_group_data" {
  description = "The resource group data for Application Insights."
  type = object({
    name     = string
    location = string
  })
}

variable "app_insights_name" {
  description = "The name of the Application Insights instance."
  type        = string
}

variable "log_analytics_name" {
  description = "The name of the Log Analytics workspace."
  type        = string
}

variable "application_type" {
  description = "The type of application being monitored."
  type        = string
  default     = "web"
}
