resource "azurerm_service_plan" "this" {
  name                   = var.app_service_plan_name
  resource_group_name    = var.resource_group_data.name
  location               = var.resource_group_data.location
  os_type                = var.os_type
  sku_name               = var.sku_name
  worker_count           = var.worker_count
  zone_balancing_enabled = var.zone_balancing_enabled

  tags = var.tags
}
