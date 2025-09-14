variable "name" {
  description = "Name of the application gateway"
  type        = string
}

variable "public_ip_allocation_method" {
  description = "type of allocation method"
  type        = string
  default     = "Static"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Location of the resource group"
  type        = string
}

# variable "subnet_name" {
#   description = "Name of the subnet"
#   type        = string
# }

variable "public_ip_sku_appg" {
  description = "type of sku"
  type        = string
  default     = "Standard"
}

variable "zones" {
  description = "A list of availability zones to be used for the Application Gateway."
  type        = list(string)
  default     = ["1", "2", "3"]
}

# variable "virtual_network_name" {
#   description = "Name of the virtual network"
#   type        = string
# }

# variable "address_prefixes" {
#   description = "cidr of the subnet"
#   type        = list(string)
# }

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

# variable "route" {
#   description = "A list of routes to be added to the route table"
#   type = list(object({
#     name           = string
#     address_prefix = string
#   }))
# }

# variable "next_hop_in_ip_address" {
#   description = "The next hop IP address for the routes"
#   type        = string
# }

variable "private_ip" {
  description = "The private IP address for the Application Gateway"
  type        = string
}

variable "frontend_port" {
  description = "List of frontend ports."
  type = list(object({
    name = string
    port = number
  }))
}

variable "backend_address_pool" {
  description = "List of backend address pools."
  type = list(object({
    name         = string
    ip_addresses = optional(list(string))
  }))
}

variable "backend_http_settings" {
  description = "List of backend HTTP settings."
  type = list(object({
    name                                = string
    cookie_based_affinity               = optional(string)
    path                                = optional(string)
    affinity_cookie_name                = optional(string)
    port                                = number
    protocol                            = string
    request_timeout                     = number
    probe_name                          = optional(string)
    pick_host_name_from_backend_address = optional(bool)
    host_name                           = optional(string)
  }))
}

variable "http_listener" {
  description = "List of HTTP listeners."
  type = list(object({
    name                           = string
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    protocol                       = string
    ssl_certificate_name           = string
  }))
}

variable "certificate_name" {
  description = "name of the Https certficate"
  type        = string
}

variable "request_routing_rule" {
  description = "List of request routing rules."
  type = list(object({
    name                       = string
    rule_type                  = string
    http_listener_name         = string
    backend_address_pool_name  = string
    backend_http_settings_name = string
    url_path_map_name          = string
    priority                   = number
  }))
}

variable "probe" {
  description = "List of probes."
  type = list(object({
    name                                      = string
    protocol                                  = string
    path                                      = string
    interval                                  = number
    timeout                                   = number
    unhealthy_threshold                       = number
    pick_host_name_from_backend_http_settings = bool
    host                                      = optional(string)
    match = optional(object({
      status_code = list(string)
      body        = string
    }))
  }))
}

variable "url_path_map" {
  type = list(object({
    name                               = string
    default_backend_address_pool_name  = string
    default_backend_http_settings_name = string
    path_rules = list(object({
      name                       = string
      paths                      = list(string)
      backend_address_pool_name  = string
      backend_http_settings_name = string
    }))
  }))
}

# variable "diagnostic_log_analytics_workspaces" {
#   description = <<-EOT
#     (Optional) list of Log Analytics Workspace IDs and log categories to store diagnostic logs (if empty, storing diagnostic logs to Log Analytics Workspace is disabled):
#       id: ID of the Log Analytics Workspace.
#       ApplicationGatewayAccessLog: Flag indicating whether the ApplicationGatewayAccessLog are sent or not (if false, ApplicationGatewayAccessLog are not sent).
#       ApplicationGatewayPerformanceLog: Flag indicating whether the ApplicationGatewayPerformanceLog are sent or not (if false, ApplicationGatewayPerformanceLog are not sent).
#       ApplicationGatewayFirewallLog: Flag indicating whether the ApplicationGatewayFirewallLog are sent or not (if false, ApplicationGatewayFirewallLog are not sent).
#   EOT
#   type = list(object({
#     id                               = string
#     ApplicationGatewayAccessLog      = bool
#     ApplicationGatewayPerformanceLog = bool
#     ApplicationGatewayFirewallLog    = bool
#   }))
#   //Enforce storing diagnostic logs in Log Analytics Workspace
# }

variable "vm_nic" {
  description = "Map of virtual machine NICs."
  type = map(object({
    network_interface_name = string
    backend_pool_name      = string
  }))
}

# variable "log_analytics_storage_account_id" {
#   description = "ID of the Storage Account for the Log Analytics Workspace."
#   type        = string
#   default     = null
# }

# variable "log_analytics_nsg_diag_categories" {
#   description = "NSG Monitoring Category details for Azure Diagnostic settings."
#   type        = list(string)
#   default     = ["NetworkSecurityGroupEvent", "NetworkSecurityGroupRuleCounter"]
# }

variable "sku" {
  description = "SKU of the application gateway"
  type = object({
    name     = string
    tier     = string
    capacity = number
  })
  default = {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }
}

variable "key_vault_info" {
  description = "Information about the key vault"
  type = object({
    name             = string
    certificate_name = string
  })
}

variable "network_info" {
  description = "Information about the network"
  type = object({
    subnet_name          = string
    virtual_network_name = string
  })
}

# variable "virtual_machines" {
#   description = "List of virtual machine private IP addresses to add to the backend pool"
#   type        = list(string)
# }



# variable "user_assigned_identity_info" {
#   description = "Information about the user assigned identity"
#   type = object({
#     name                = string
#     resource_group_name = string
#   })
# }

# variable "tags" {
#   description = "A mapping of tags to assign to the resource"
#   type        = map(string)
# }

#  variable "diagnostic_log_analytics_workspaces" {
#    description = <<-EOT
#      (Optional) list of Log Analytics Workspace IDs and log categories to store diagnostic logs (if empty, storing diagnostic logs to Log Analytics Workspace is disabled):
#        id: ID of the Log Analytics Workspace.
#        ApplicationGatewayAccessLog: Flag indicating whether the ApplicationGatewayAccessLog are sent or not (if false, ApplicationGatewayAccessLog are not sent).
#        ApplicationGatewayPerformanceLog: Flag indicating whether the ApplicationGatewayPerformanceLog are sent or not (if false, ApplicationGatewayPerformanceLog are not sent).
#        ApplicationGatewayFirewallLog: Flag indicating whether the ApplicationGatewayFirewallLog are sent or not (if false, ApplicationGatewayFirewallLog are not sent).
#    EOT
#    type = list(object({
#      id                               = string
#      ApplicationGatewayAccessLog      = bool
#      ApplicationGatewayPerformanceLog = bool
#      ApplicationGatewayFirewallLog    = bool
#    }))
#    //Enforce storing diagnostic logs in Log Analytics Workspace
# }

