locals {
  front_door_id   = var.create_front_door ? azurerm_cdn_frontdoor_profile.this[0].id : data.azurerm_cdn_frontdoor_profile.existing[0].id
  front_door_name = var.create_front_door ? azurerm_cdn_frontdoor_profile.this[0].name : data.azurerm_cdn_frontdoor_profile.existing[0].name
  endpoint_name   = coalesce(var.endpoint_name, var.front_door_name)

  # Aplatissement de la map origins: "${group_key}__${origin_key}" => origin avec group_key
  origins = merge([
    for group_key, group in var.origin_groups : {
      for origin_key, origin in group.origins :
      "${group_key}__${origin_key}" => merge(origin, { group_key = group_key })
    }
  ]...)
}

# ---- Profil Azure Front Door ----

data "azurerm_cdn_frontdoor_profile" "existing" {
  count               = var.create_front_door ? 0 : 1
  name                = var.front_door_name
  resource_group_name = var.resource_group_data.name
}

resource "azurerm_cdn_frontdoor_profile" "this" {
  count               = var.create_front_door ? 1 : 0
  name                = var.front_door_name
  resource_group_name = var.resource_group_data.name
  sku_name            = var.sku_name
  tags                = var.tags
}

# ---- Endpoint ----

resource "azurerm_cdn_frontdoor_endpoint" "this" {
  name                     = local.endpoint_name
  cdn_frontdoor_profile_id = local.front_door_id
  tags                     = var.tags
}

# ---- Groupes d'origine ----

resource "azurerm_cdn_frontdoor_origin_group" "this" {
  for_each = var.origin_groups

  name                     = each.value.name
  cdn_frontdoor_profile_id = local.front_door_id

  dynamic "health_probe" {
    for_each = each.value.health_probe != null ? [each.value.health_probe] : []
    content {
      interval_in_seconds = health_probe.value.interval_in_seconds
      path                = health_probe.value.path
      protocol            = health_probe.value.protocol
      request_type        = health_probe.value.request_type
    }
  }

  load_balancing {
    sample_size                        = try(each.value.load_balancing.sample_size, 4)
    successful_samples_required        = try(each.value.load_balancing.successful_samples_required, 3)
    additional_latency_in_milliseconds = try(each.value.load_balancing.additional_latency_in_milliseconds, 50)
  }
}

# ---- Origines ----

resource "azurerm_cdn_frontdoor_origin" "this" {
  for_each = local.origins

  name                           = each.value.name
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.this[each.value.group_key].id
  host_name                      = each.value.host_name
  http_port                      = each.value.http_port
  https_port                     = each.value.https_port
  origin_host_header             = each.value.origin_host_header
  priority                       = each.value.priority
  weight                         = each.value.weight
  certificate_name_check_enabled = each.value.certificate_name_check_enabled
  enabled                        = each.value.enabled
}

# ---- Routes ----

resource "azurerm_cdn_frontdoor_route" "this" {
  for_each = var.routes

  name                          = each.value.name
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.this.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.this[each.value.origin_group_key].id
  cdn_frontdoor_origin_ids = [
    for flat_key, origin in local.origins :
    azurerm_cdn_frontdoor_origin.this[flat_key].id
    if origin.group_key == each.value.origin_group_key
  ]
  forwarding_protocol    = each.value.forwarding_protocol
  patterns_to_match      = each.value.patterns_to_match
  https_redirect_enabled = each.value.https_redirect_enabled
  supported_protocols    = each.value.supported_protocols
  enabled                = each.value.enabled
  link_to_default_domain = each.value.link_to_default_domain

  dynamic "cache" {
    for_each = each.value.cache != null ? [each.value.cache] : []
    content {
      query_string_caching_behavior = cache.value.query_string_caching_behavior
      query_strings                 = cache.value.query_strings
      compression_enabled           = cache.value.compression_enabled
      content_types_to_compress     = cache.value.content_types_to_compress
    }
  }
}

# ---- Politique WAF ----

resource "azurerm_cdn_frontdoor_firewall_policy" "this" {
  count               = var.waf_policy != null ? 1 : 0
  name                = var.waf_policy.name
  resource_group_name = var.resource_group_data.name
  sku_name            = var.sku_name
  mode                = var.waf_policy.mode
  enabled             = var.waf_policy.enabled
  redirect_url        = var.waf_policy.redirect_url

  custom_block_response_status_code = var.waf_policy.custom_block_response_status_code
  custom_block_response_body        = var.waf_policy.custom_block_response_body

  dynamic "managed_rule" {
    for_each = var.waf_policy.managed_rules
    content {
      type    = managed_rule.value.type
      version = managed_rule.value.version
      action  = managed_rule.value.action
    }
  }

  dynamic "custom_rule" {
    for_each = var.waf_policy.custom_rules
    content {
      name                           = custom_rule.value.name
      action                         = custom_rule.value.action
      enabled                        = custom_rule.value.enabled
      priority                       = custom_rule.value.priority
      type                           = custom_rule.value.type
      rate_limit_duration_in_minutes = custom_rule.value.rate_limit_duration_in_minutes
      rate_limit_threshold           = custom_rule.value.rate_limit_threshold

      dynamic "match_condition" {
        for_each = custom_rule.value.match_conditions
        content {
          match_variable     = match_condition.value.match_variable
          operator           = match_condition.value.operator
          negation_condition = match_condition.value.negation_condition
          match_values       = match_condition.value.match_values
          transforms         = match_condition.value.transforms
        }
      }
    }
  }

  tags = var.tags
}

# ---- Politique de sécurité (liaison WAF ↔ endpoint) ----

resource "azurerm_cdn_frontdoor_security_policy" "this" {
  count                    = var.waf_policy != null ? 1 : 0
  name                     = "${var.waf_policy.name}-security-policy"
  cdn_frontdoor_profile_id = local.front_door_id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.this[0].id
      association {
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_endpoint.this.id
        }
        patterns_to_match = ["/*"]
      }
    }
  }
}
