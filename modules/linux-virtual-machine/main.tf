module "naming" {
  source = "git@github.com:h0livier/terraform-naming-helper.git?ref=main"

  data = {
    client  = var.naming.data.client
    project = var.naming.data.project
    type    = var.naming.data.type
  }

  role        = var.naming.role
  environment = var.naming.environment
}

resource "azurerm_network_interface" "this" {
  name                = "${module.naming.name}-nic"
  location            = var.location
  resource_group_name = module.naming.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "this" {
  name                            = module.naming.name
  location                        = var.location
  resource_group_name             = module.naming.resource_group
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_ssh_key == null ? var.admin_password : null
  disable_password_authentication = var.admin_ssh_key != null

  network_interface_ids = [azurerm_network_interface.this.id]

  dynamic "admin_ssh_key" {
    for_each = var.admin_ssh_key != null ? [var.admin_ssh_key] : []

    content {
      username   = admin_ssh_key.value.username
      public_key = admin_ssh_key.value.public_key
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  tags = var.tags

  lifecycle {
    precondition {
      condition     = var.admin_ssh_key != null || var.admin_password != null
      error_message = "At least one authentication method must be provided: admin_ssh_key or admin_password."
    }
  }
}

resource "azurerm_managed_disk" "this" {
  name                 = "${module.naming.name}-disk"
  location             = var.location
  resource_group_name  = module.naming.resource_group
  storage_account_type = var.data_disk_storage_account_type
  create_option        = "Empty"
  disk_size_gb         = var.data_disk_size_gb

  tags = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "this" {
  managed_disk_id    = azurerm_managed_disk.this.id
  virtual_machine_id = azurerm_linux_virtual_machine.this.id
  lun                = var.data_disk_lun
  caching            = "ReadWrite"
}
