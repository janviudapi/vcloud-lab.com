variable "name" {
  description = "The name of the virtual network peering."
}

variable "resource_group_name" {
  description = "The name of the resource group in which the virtual network peering should be created."
}

variable "virtual_network_name" {
  description = "The name of the virtual network in which the virtual network peering should be created."
}

variable "remote_virtual_network_id" {
  description = "The ID of the remote virtual network to which the virtual network should be peered."
}
