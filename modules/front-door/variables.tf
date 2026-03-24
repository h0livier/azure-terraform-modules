variable "resource_group_data" {
  description = "The resource group data for the Front Door module."
  type = object({
    name     = string
    location = string
  })
}

variable "front_door_name" {
  description = "The name of the Azure Front Door profile."
  type        = string
}

variable "sku_name" {
  description = "The SKU name of the Front Door profile. Accepted values: Standard_AzureFrontDoor or Premium_AzureFrontDoor."
  type        = string
  default     = "Standard_AzureFrontDoor"

  validation {
    condition     = contains(["Standard_AzureFrontDoor", "Premium_AzureFrontDoor"], var.sku_name)
    error_message = "sku_name must be Standard_AzureFrontDoor or Premium_AzureFrontDoor."
  }
}

variable "create_front_door" {
  description = "Whether to create a new Front Door profile. Set to false to use an existing one."
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

variable "endpoint_name" {
  description = "The name of the Front Door endpoint. Defaults to the front_door_name."
  type        = string
  default     = null
}

variable "origin_groups" {
  description = "Map of origin groups to create. Each group contains origins and optional health probe and load balancing configuration."
  type = map(object({
    name = string
    health_probe = optional(object({
      interval_in_seconds = optional(number, 100)
      path                = optional(string, "/")
      protocol            = optional(string, "Https")
      request_type        = optional(string, "HEAD")
    }))
    load_balancing = optional(object({
      sample_size                        = optional(number, 4)
      successful_samples_required        = optional(number, 3)
      additional_latency_in_milliseconds = optional(number, 50)
    }))
    origins = map(object({
      name                           = string
      host_name                      = string
      http_port                      = optional(number, 80)
      https_port                     = optional(number, 443)
      origin_host_header             = optional(string)
      priority                       = optional(number, 1)
      weight                         = optional(number, 1000)
      certificate_name_check_enabled = optional(bool, true)
      enabled                        = optional(bool, true)
    }))
  }))
  default = {}
}

variable "routes" {
  description = "Map of routes to create. Each route references an origin group by its key."
  type = map(object({
    name                   = string
    origin_group_key       = string
    patterns_to_match      = list(string)
    forwarding_protocol    = optional(string, "HttpsOnly")
    https_redirect_enabled = optional(bool, true)
    supported_protocols    = optional(list(string), ["Http", "Https"])
    enabled                = optional(bool, true)
    link_to_default_domain = optional(bool, true)
    cache = optional(object({
      query_string_caching_behavior = optional(string, "IgnoreQueryString")
      query_strings                 = optional(list(string), [])
      compression_enabled           = optional(bool, false)
      content_types_to_compress     = optional(list(string), [])
    }))
  }))
  default = {}
}

variable "waf_policy" {
  description = "WAF policy configuration for Front Door security rules. Managed rules require Premium SKU."
  type = object({
    name                              = string
    mode                              = optional(string, "Prevention")
    enabled                           = optional(bool, true)
    redirect_url                      = optional(string)
    custom_block_response_status_code = optional(number, 403)
    custom_block_response_body        = optional(string)
    managed_rules = optional(list(object({
      type    = string
      version = string
      action  = optional(string, "Block")
    })), [])
    custom_rules = optional(list(object({
      name                           = string
      action                         = string
      enabled                        = optional(bool, true)
      priority                       = number
      type                           = string
      rate_limit_duration_in_minutes = optional(number, 1)
      rate_limit_threshold           = optional(number, 10)
      match_conditions = list(object({
        match_variable     = string
        operator           = string
        negation_condition = optional(bool, false)
        match_values       = list(string)
        transforms         = optional(list(string), [])
      }))
    })), [])
  })
  default = null
}
