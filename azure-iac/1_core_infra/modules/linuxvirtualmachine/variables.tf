variable "name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "location" {
  description = "Location of the virtual machine"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "private_ip_address" {
  description = "Private IP address of the virtual machine"
  type        = string
}

variable "size" {
  description = "Size of the virtual machine"
  type        = string
}

variable "admin_username" {
  description = "Admin username of the virtual machine"
  type        = string
}

# variable "admin_password" {
#   description = "Admin password of the virtual machine"
#   type        = string
# }

variable "ext_settings" {
  description = "File URIs for the virtual machine extension"
  type = object({
    fileUris         = list(string)
    commandToExecute = string
  })
  default = {
    fileUris = [
      "https://vcloudlabdemo01scripts.blob.core.windows.net/scripts/ConfigureRemotingForAnsible.ps1"
    ]
    commandToExecute = "powershell -ExecutionPolicy Unrestricted -File ConfigureRemotingForAnsible.ps1"
  }
  #"https://vcloudlabdemo01scripts.blob.core.windows.net/scripts/ConfigureRemotingForAnsible.ps1"
  # "powershell -ExecutionPolicy Unrestricted -File ConfigureRemotingForAnsible.ps1"
}

variable "key_vault_info" {
  description = "Information about the key vault"
  type = object({
    name                = string
    secret_name         = string
    resource_group_name = string
  })
}

variable "os_disk" {
  description = "OS disk of the virtual machine"
  #type = map(string)
  type = object({
    caching              = string
    storage_account_type = string
  })
}

variable "source_image_reference" {
  description = "Source image reference of the virtual machine"
  #type = map(string)
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "tags" {
  description = "Tags for the virtual machine"
  type        = map(string)
}

variable "identity" {
  description = "Identity of the virtual machine"
  type = object({
    user_assigned_identity_name = string
    resource_group_name         = string
  })
}