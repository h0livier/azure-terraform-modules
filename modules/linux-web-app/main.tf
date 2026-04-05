resource "azurerm_service_plan" "this" {
  name                = var.service_plan_name
  resource_group_name = var.resource_group_data.name
  location            = var.resource_group_data.location
  os_type             = "Linux"
  sku_name            = var.service_plan_sku_name

  tags = var.tags
}

resource "azurerm_linux_web_app" "this" {
  name                = var.linux_web_app_name
  resource_group_name = var.resource_group_data.name
  location            = var.resource_group_data.location
  service_plan_id     = azurerm_service_plan.this.id
  https_only          = var.https_only

  app_settings = var.app_settings

  site_config {
    always_on = var.always_on

    dynamic "application_stack" {
      for_each = var.application_stack != null ? [var.application_stack] : []

      content {
        docker_image_name   = application_stack.value.docker_image_name
        docker_registry_url = application_stack.value.docker_registry_url
        dotnet_version      = application_stack.value.dotnet_version
        go_version          = application_stack.value.go_version
        java_server         = application_stack.value.java_server
        java_server_version = application_stack.value.java_server_version
        java_version        = application_stack.value.java_version
        node_version        = application_stack.value.node_version
        php_version         = application_stack.value.php_version
        python_version      = application_stack.value.python_version
        ruby_version        = application_stack.value.ruby_version
      }
    }
  }

  identity {
    type = var.identity_type
  }

  tags = var.tags
}
