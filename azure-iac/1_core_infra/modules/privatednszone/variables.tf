variable "name" {
  description = "The name of the Private DNS Zone"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which the Private DNS Zone should be created"
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the Virtual Network to link to the Private DNS Zone"
  type        = string
}