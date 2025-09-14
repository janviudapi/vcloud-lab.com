variable "resource_group_info" {
  description = "Information about the resource group"
  type = list(object({
    name     = string
    location = string
    tags     = map(string)
  }))
}

variable "virtual_network_info" {
  description = "Information about the virtual network"
  type = list(object({
    name                = string
    resource_group_name = string
    address_space       = list(string)
    tags                = map(string)
  }))
}

variable "subnet_info" {
  description = "Information about the subnet"
  type = list(object({
    name                 = string
    virtual_network_name = string
    address_space        = list(string)

    location = string

    nsg_rules = optional(list(object({
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
    })))

  }))
}

variable "vnet_peering_info" {
  description = "Information about the virtual network peering"
  type = list(object({
    name                      = string
    resource_group_name       = string
    virtual_network_name      = string
    remote_virtual_network_id = string

  }))
}

variable "bastion_host_info" {
  description = "Information about the bastion host"
  type = list(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
    tags                 = map(string)
  }))
}

variable "upload_to_storage_account_info" {
  description = "Information about the upload to storage account"
  type = list(object({
    name                     = string
    resource_group_name      = string
    account_tier             = string
    account_replication_type = string
    tags                     = map(string)
  }))
}

variable "windows_virtual_machine_info" {
  description = "Information about the Windows virtual machine"
  type = list(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
    subnet_name          = string
    private_ip_address   = string
    vm_size              = string
    admin_username       = string
    #admin_password       = string
    user_assigned_identity_name = string
    key_vault_info = object({
      name                = string
      secret_name         = string
      resource_group_name = string
    })
    os_disk = object({
      caching              = string
      storage_account_type = string
    })
    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })
    # ext_settings = object({
    #   fileUris         = list(string)
    #   commandToExecute = string
    # })
    tags = map(string)
  }))
}

variable "data_disks" {
  description = "(Optional) List of data disks. The Logical Unit Number (LUN) needs to be a unique numeric identifier > 0."
  type = list(object({
    lun                  = number
    disk_size_gb         = string
    caching              = optional(string, "ReadWrite")
    storage_account_type = optional(string, "StandardSSD_LRS")
  }))
  default = []
}

# variable "linux_virtual_machine_info" {
#   description = "Information about the Windows virtual machine"
#   type = list(object({
#     name                 = string
#     resource_group_name  = string
#     virtual_network_name = string
#     subnet_name          = string
#     private_ip_address   = string
#     vm_size              = string
#     admin_username       = string
#     #admin_password       = string
#     key_vault_info = object({
#       name                = string
#       secret_name         = string
#       resource_group_name = string
#     })
#     os_disk = object({
#       caching              = string
#       storage_account_type = string
#     })
#     source_image_reference = object({
#       publisher = string
#       offer     = string
#       sku       = string
#       version   = string
#     })
#     ext_settings = object({
#       fileUris         = list(string)
#       commandToExecute = string
#     })
#     identity = object({
#       resource_group_name         = string
#       user_assigned_identity_name = string
#     })
#     tags = map(string)
#   }))
# }

# variable "application_gateway_info" {
#   type = list(object({
#     name                = string
#     resource_group_name = string
#     location            = string
#     sku = object({
#       name     = string
#       tier     = string
#       capacity = number
#     })
#     network_info = object({
#       subnet_name          = string
#       virtual_network_name = string
#       resource_group_name  = string
#     })
#     key_vault_info = object({
#       name                = string
#       certificate_name    = string
#       resource_group_name = string
#     })
#     user_assigned_identity_info = object({
#       name                = string
#       resource_group_name = string
#     })
#     tags = map(string)
#   }))
# }

# variable "application_gateway_info" {
#   description = "Information about the application gateway"
#   type = list(object({
#     name                        = string
#     resource_group_name         = string
#     location                    = string
#     public_ip_allocation_method = string
#     public_ip_sku_appg          = string
#     private_ip                  = string
#     zones                       = list(string)
#     network_info = object({
#       subnet_name          = string
#       virtual_network_name = string
#     })
#     sku = object({
#       name     = string
#       tier     = string
#       capacity = number
#     })
#     frontend_port = list(object({
#       name = string
#       port = number
#     }))
#     backend_address_pool = list(object({
#       name = string
#       #fqdns = list(string)
#       ip_addresses = list(string)
#     }))
#     vm_nic = map(object({
#       network_interface_name = string
#       backend_pool_name      = string
#     }))
#     backend_http_settings = list(object({
#       name                                = string
#       cookie_based_affinity               = optional(string)
#       path                                = optional(string)
#       affinity_cookie_name                = optional(string)
#       port                                = number
#       protocol                            = string
#       request_timeout                     = number
#       probe_name                          = optional(string)
#       pick_host_name_from_backend_address = optional(bool)
#       host_name                           = optional(string)
#     }))
#     http_listener = list(object({
#       name                           = string
#       frontend_ip_configuration_name = string
#       frontend_port_name             = string
#       protocol                       = string
#       ssl_certificate_name           = string
#     }))
#     request_routing_rule = list(object({
#       name                       = string
#       rule_type                  = string
#       http_listener_name         = string
#       backend_address_pool_name  = string
#       backend_http_settings_name = string
#       url_path_map_name          = string
#       priority                   = number
#     }))
#     probe = list(object({
#       name                                      = string
#       protocol                                  = string
#       path                                      = string
#       interval                                  = number
#       timeout                                   = number
#       unhealthy_threshold                       = number
#       pick_host_name_from_backend_http_settings = bool
#       host                                      = optional(string)
#       match = optional(object({
#         status_code = list(string)
#         body        = string
#       }))
#     }))
#     url_path_map = list(object({
#       name                               = string
#       default_backend_address_pool_name  = string
#       default_backend_http_settings_name = string
#       path_rules = list(object({
#         name                       = string
#         paths                      = list(string)
#         backend_address_pool_name  = string
#         backend_http_settings_name = string
#       }))
#     }))


#     nsg_rules = list(object({
#       name                         = string
#       priority                     = number
#       direction                    = string
#       access                       = string
#       protocol                     = string
#       source_port_range            = optional(string)
#       source_port_ranges           = optional(list(string))
#       destination_port_range       = optional(string)
#       source_address_prefix        = optional(string)
#       source_address_prefixes      = optional(list(string))
#       destination_address_prefix   = optional(string)
#       destination_address_prefixes = optional(list(string))
#       destination_port_ranges      = optional(list(string))
#     }))
#     # route = list(object({
#     #   name                   = string
#     #   address_prefix         = string
#     #   next_hop_type          = string
#     #   next_hop_in_ip_address = optional(string)
#     # }))

#     # next_hop_in_ip_address = optional(string)

#     key_vault_info = object({
#       name             = string
#       certificate_name = string
#     })

#     certificate_name = string

#     # tags = map(string)
#   }))

# }

variable "storage_account_with_ep_info" {
  description = "Information about the storage account"
  type = list(object({
    name                     = string
    resource_group_name      = string
    account_kind             = string
    account_tier             = string
    account_replication_type = string
    virtual_network_name     = string
    subnet_name              = string
    tags                     = map(string)
  }))
}

variable "keyvault_info" {
  type = object({
    name                = string
    resource_group_name = string
    location            = string
    sku_kv              = string
    #access_policies                      = var.access_policies
    #role_assignments                     = var.role_assignments
    network_acls = object({
      bypass                     = optional(string, "None")
      default_action             = optional(string, "Deny")
      ip_rules                   = optional(list(string), [])
      virtual_network_subnet_ids = optional(list(string), [])
    })
    runner_ip                            = bool
    public_network_access_enabled        = bool
    purge_protection_enabled             = bool
    key_vault_admin_username_secret_name = string
    key_vault_admin_password_secret_name = string
    soft_delete_retention_days           = number
    # log_analytics_workspace_id = var.log_analytics_workspace_id
    # log_analytics_workspace_enable_logs = var.log_analytics_workspace_enable_logs
    # log_analytics_storage_account_id = var.log_analytics_storage_account_id
  })
}

variable "private_dns_zone_info" {
  description = "Information about the private DNS zone"
  type = list(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
  }))
}

# variable "recovery_services_vault_info" {
#   description = "Information about the recovery services vault"
#   type = list(object({
#     name                = string
#     resource_group_name = string
#     location            = string
#     sku                 = string
#     soft_delete_enabled = bool
#     backup_policy = object({
#       name     = string
#       timezone = string
#       backup = object({
#         frequency = string
#         time      = string
#       })
#       retention_daily = object({
#         count = number
#       })
#       retention_weekly = object({
#         count    = number
#         weekdays = list(string)
#       })
#       retention_monthly = object({
#         count    = number
#         weekdays = list(string)
#         weeks    = list(string)
#       })
#       retention_yearly = object({
#         count    = number
#         weekdays = list(string)
#         weeks    = list(string)
#         months   = list(string)
#       })
#     })
#   }))
# }

# variable "backup_virtual_machine_info" {
#   description = "Information about the backup virtual machine"
#   type = list(object({
#     virtual_machine_name         = string
#     resource_group_name          = string
#     recovery_services_vault_name = string
#     backup_policy_name           = string
#   }))
# }