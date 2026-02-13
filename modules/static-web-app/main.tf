resource "azurerm_static_web_app" "this" {
  name                = var.static_web_app_name
  resource_group_name = var.resource_group_data.name
  location            = var.resource_group_data.location

  sku_tier = "Free"
  sku_size = "Free"
  
  app_settings = var.app_settings
}