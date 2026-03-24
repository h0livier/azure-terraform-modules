output "front_door_id" {
  description = "The ID of the Front Door profile."
  value       = local.front_door_id
}

output "front_door_name" {
  description = "The name of the Front Door profile."
  value       = local.front_door_name
}

output "endpoint_id" {
  description = "The ID of the Front Door endpoint."
  value       = azurerm_cdn_frontdoor_endpoint.this.id
}

output "endpoint_hostname" {
  description = "The hostname of the Front Door endpoint."
  value       = azurerm_cdn_frontdoor_endpoint.this.host_name
}

output "origin_group_ids" {
  description = "Map of origin group IDs keyed by the origin group map key."
  value = {
    for key, group in azurerm_cdn_frontdoor_origin_group.this :
    key => group.id
  }
}

output "origin_ids" {
  description = "Map of origin IDs keyed by group_key__origin_key."
  value = {
    for key, origin in azurerm_cdn_frontdoor_origin.this :
    key => origin.id
  }
}

output "route_ids" {
  description = "Map of route IDs keyed by the route map key."
  value = {
    for key, route in azurerm_cdn_frontdoor_route.this :
    key => route.id
  }
}

output "waf_policy_id" {
  description = "The ID of the WAF firewall policy, if created."
  value       = var.waf_policy != null ? azurerm_cdn_frontdoor_firewall_policy.this[0].id : null
}

output "security_policy_id" {
  description = "The ID of the Front Door security policy, if created."
  value       = var.waf_policy != null ? azurerm_cdn_frontdoor_security_policy.this[0].id : null
}
