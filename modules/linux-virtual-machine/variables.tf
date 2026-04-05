variable "naming" {
  description = "Inputs forwarded to the naming helper module."
  type = object({
    data = object({
      client  = string
      project = string
      type    = string
    })
    role        = string
    environment = string
  })
}

variable "location" {
  description = "The Azure region where the resources will be created."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to attach the network interface to."
  type        = string
}

variable "admin_username" {
  description = "The administrator username for the virtual machine."
  type        = string
}

variable "admin_password" {
  description = "The administrator password for the virtual machine. Required when admin_ssh_key is not provided."
  type        = string
  sensitive   = true
  default     = null
}

variable "admin_ssh_key" {
  description = "SSH public key block for the virtual machine. When provided, password authentication is disabled."
  type = object({
    username   = string
    public_key = string
  })
  default = null
}

variable "vm_size" {
  description = "The size of the virtual machine (e.g. Standard_B2s, Standard_D2s_v3)."
  type        = string
  default     = "Standard_B2s"
}

variable "os_disk_storage_account_type" {
  description = "The storage account type for the OS disk (e.g. Standard_LRS, Premium_LRS)."
  type        = string
  default     = "Standard_LRS"
}

variable "source_image_reference" {
  description = "The source image reference for the virtual machine."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

variable "data_disk_size_gb" {
  description = "The size in GB of the managed data disk."
  type        = number
  default     = 32
}

variable "data_disk_storage_account_type" {
  description = "The storage account type for the managed data disk (e.g. Standard_LRS, Premium_LRS)."
  type        = string
  default     = "Standard_LRS"
}

variable "data_disk_lun" {
  description = "The LUN (Logical Unit Number) for the data disk attachment."
  type        = number
  default     = 0
}

variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}
