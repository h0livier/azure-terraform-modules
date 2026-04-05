output "vm_id" {
  description = "The ID of the Linux virtual machine."
  value       = azurerm_linux_virtual_machine.this.id
}

output "vm_name" {
  description = "The name of the Linux virtual machine."
  value       = azurerm_linux_virtual_machine.this.name
}

output "vm_private_ip_address" {
  description = "The private IP address of the Linux virtual machine."
  value       = azurerm_linux_virtual_machine.this.private_ip_address
}

output "network_interface_id" {
  description = "The ID of the network interface attached to the virtual machine."
  value       = azurerm_network_interface.this.id
}

output "managed_disk_id" {
  description = "The ID of the managed data disk attached to the virtual machine."
  value       = azurerm_managed_disk.this.id
}

output "managed_disk_name" {
  description = "The name of the managed data disk attached to the virtual machine."
  value       = azurerm_managed_disk.this.name
}
