variable "name" {
  description = "The name of the subnet"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the subnet"
  type        = string
}

variable "location" {
  description = "The Azure location where the nsg will be created"
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the virtual network in which to create the subnet"
  type        = string
}

variable "address_prefixes" {
  description = "The address prefixes to use for the subnet"
  type        = list(string)
}

variable "nsg_rules" {
  description = "Map of subnet names to their respective NSG rules"
  type = list(object({
    name                         = string
    priority                     = number
    direction                    = string
    access                       = string
    protocol                     = string
    source_port_range            = optional(string)
    source_port_ranges           = optional(list(string))
    destination_port_range       = optional(string)
    source_address_prefix        = optional(string)
    source_address_prefixes      = optional(list(string))
    destination_address_prefix   = optional(string)
    destination_address_prefixes = optional(list(string))
    destination_port_ranges      = optional(list(string))
  }))
}