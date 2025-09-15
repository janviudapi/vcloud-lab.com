variable "application_gateway_info" {
  description = "Information about the application gateway"
  type = list(object({
    name                        = string
    resource_group_name         = string
    location                    = string
    public_ip_allocation_method = string
    public_ip_sku_appg          = string
    private_ip                  = string
    zones                       = list(string)
    network_info = object({
      subnet_name          = string
      virtual_network_name = string
    })
    sku = object({
      name     = string
      tier     = string
      capacity = number
    })
    frontend_port = list(object({
      name = string
      port = number
    }))
    backend_address_pool = list(object({
      name = string
      #fqdns = list(string)
      ip_addresses = list(string)
    }))
    vm_nic = map(object({
      network_interface_name = string
      backend_pool_name      = string
    }))
    backend_http_settings = list(object({
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
    http_listener = list(object({
      name                           = string
      frontend_ip_configuration_name = string
      frontend_port_name             = string
      protocol                       = string
      ssl_certificate_name           = string
    }))
    request_routing_rule = list(object({
      name                       = string
      rule_type                  = string
      http_listener_name         = string
      backend_address_pool_name  = string
      backend_http_settings_name = string
      url_path_map_name          = string
      priority                   = number
    }))
    probe = list(object({
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
    url_path_map = list(object({
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


    # nsg_rules = list(object({
    #   name                         = string
    #   priority                     = number
    #   direction                    = string
    #   access                       = string
    #   protocol                     = string
    #   source_port_range            = optional(string)
    #   source_port_ranges           = optional(list(string))
    #   destination_port_range       = optional(string)
    #   source_address_prefix        = optional(string)
    #   source_address_prefixes      = optional(list(string))
    #   destination_address_prefix   = optional(string)
    #   destination_address_prefixes = optional(list(string))
    #   destination_port_ranges      = optional(list(string))
    # }))
    
    # route = list(object({
    #   name                   = string
    #   address_prefix         = string
    #   next_hop_type          = string
    #   next_hop_in_ip_address = optional(string)
    # }))

    # next_hop_in_ip_address = optional(string)

    key_vault_info = object({
      name             = string
      certificate_name = string
    })

    certificate_name               = string
    encrypted_certificate_password = string

    # tags = map(string)
  }))
}

# variable "keyvault_info" {
#   type = object({
#     name                = string
#     resource_group_name = string
#     location            = string
#     sku_kv              = string
#     #access_policies                      = var.access_policies
#     #role_assignments                     = var.role_assignments
#     network_acls = object({
#       bypass                     = optional(string, "None")
#       default_action             = optional(string, "Deny")
#       ip_rules                   = optional(list(string), [])
#       virtual_network_subnet_ids = optional(list(string), [])
#     })
#     runner_ip                            = bool
#     public_network_access_enabled        = bool
#     purge_protection_enabled             = bool
#     key_vault_admin_username_secret_name = string
#     key_vault_admin_password_secret_name = string
#     soft_delete_retention_days           = number
#     # log_analytics_workspace_id = var.log_analytics_workspace_id
#     # log_analytics_workspace_enable_logs = var.log_analytics_workspace_enable_logs
#     # log_analytics_storage_account_id = var.log_analytics_storage_account_id
#   })
# }