resource "azurerm_public_ip" "gateway_ip" {
  name                = "${var.name}-pip-appgw"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.public_ip_allocation_method
  sku                 = var.public_ip_sku_appg
  zones               = var.zones
}

# resource "azurerm_subnet" "appgw_subnet" {
#   name                 = var.subnet_name
#   resource_group_name  = var.resource_group_name
#   virtual_network_name = var.virtual_network_name
#   address_prefixes     = var.address_prefixes
# }

resource "azurerm_network_security_group" "appgw_nsg" {
  name                = "${var.name}-nsg-appgw"
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                         = security_rule.value.name
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_port_range            = security_rule.value.source_port_range
      destination_port_range       = security_rule.value.destination_port_range
      source_address_prefix        = security_rule.value.source_address_prefix
      destination_address_prefix   = security_rule.value.destination_address_prefix
      source_address_prefixes      = security_rule.value.source_address_prefixes
      destination_address_prefixes = security_rule.value.destination_address_prefixes
      source_port_ranges           = security_rule.value.source_port_ranges
      destination_port_ranges      = security_rule.value.destination_port_ranges

    }
  }
}

resource "azurerm_subnet_network_security_group_association" "appgw_nsg_association" {
  subnet_id                 = data.azurerm_subnet.appgw_subnet_info.id
  network_security_group_id = azurerm_network_security_group.appgw_nsg.id
}

# resource "azurerm_route_table" "gatewayrt" {
#   name                          = "${var.name}-rt-appgw"
#   location                      = var.location
#   resource_group_name           = var.resource_group_name
#   bgp_route_propagation_enabled = true
#   # depends_on = [
#   #   azurerm_subnet.appgw_subnet
#   # ]

#   dynamic "route" {
#     for_each = var.route

#     content {
#       name                   = route.value.name
#       address_prefix         = route.value.address_prefix
#       next_hop_type          = "VirtualAppliance"
#       next_hop_in_ip_address = var.next_hop_in_ip_address
#     }
#   }
#   tags = {
#     environment = "Production"
#   }
# }

# resource "azurerm_subnet_route_table_association" "appgw_rt" {
#   subnet_id      = data.azurerm_subnet.appgw_subnet_info.id
#   route_table_id = azurerm_route_table.gatewayrt.id
# }

resource "azurerm_user_assigned_identity" "appgw_identity" {
  name                = "${var.name}-uai-appgw"
  resource_group_name = var.resource_group_name
  location            = var.location
}

# resource "azurerm_key_vault_access_policy" "appgw_access_policy" { 
#   key_vault_id = data.azurerm_key_vault.keyvaultinfo.id
#   tenant_id    = data.azurerm_client_config.subscriptioninfo.tenant_id
#   object_id    = azurerm_user_assigned_identity.appgw_identity.principal_id
#   certificate_permissions = ["Get", "List", ]
#   secret_permissions = [ "Get", "List" ]
# }

# resource "azurerm_role_assignment" "kv_secrets_role_assignment" {
#   principal_id         = azurerm_user_assigned_identity.appgw_identity.principal_id
#   role_definition_name = "Key Vault Secrets Officer"
#   scope                = data.azurerm_key_vault.keyvaultinfo.id
#   # depends_on = [
#   #   azurerm_key_vault_access_policy.appgw_access_policy
#   # ]
# }

resource "azurerm_role_assignment" "kv_certificate_role_assignment" {
  principal_id         = azurerm_user_assigned_identity.appgw_identity.principal_id
  role_definition_name = "Key Vault Administrator"
  scope                = data.azurerm_key_vault.keyvaultinfo.id
  # depends_on = [
  #   #azurerm_key_vault_access_policy.appgw_access_policy,
  #   #azurerm_role_assignment.kv_secrets_role_assignment
  # ]
}

resource "azurerm_application_gateway" "appgw" {
  name                = "${var.name}-appgw"
  location            = var.location
  resource_group_name = var.resource_group_name
  zones               = var.zones

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.appgw_identity.id
    ]
  }
  sku {
    name     = var.sku.name
    tier     = var.sku.tier
    capacity = var.sku.capacity
  }

  gateway_ip_configuration {
    name      = "${var.name}-gw-ip-appgw"
    subnet_id = data.azurerm_subnet.appgw_subnet_info.id
  }

  frontend_ip_configuration {
    name                 = "fip-pip-appgw-${var.name}"
    public_ip_address_id = azurerm_public_ip.gateway_ip.id
  }

  # For Private IP
  frontend_ip_configuration {
    name                          = "fip-pvip-appgw-${var.name}"
    private_ip_address            = var.private_ip
    private_ip_address_allocation = "Static"
    subnet_id                     = data.azurerm_subnet.appgw_subnet_info.id
  }


  dynamic "frontend_port" {
    for_each = var.frontend_port
    content {
      name = frontend_port.value.name
      port = frontend_port.value.port
    }
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pool
    content {
      name = backend_address_pool.value.name
      #  fqdns        = backend_address_pool.value.fqdns
      ip_addresses = backend_address_pool.value.ip_addresses

    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    content {
      name                                = backend_http_settings.value.name
      cookie_based_affinity               = backend_http_settings.value.cookie_based_affinity
      path                                = backend_http_settings.value.path
      port                                = backend_http_settings.value.port
      protocol                            = backend_http_settings.value.protocol
      request_timeout                     = backend_http_settings.value.request_timeout
      probe_name                          = backend_http_settings.value.probe_name
      pick_host_name_from_backend_address = backend_http_settings.value.pick_host_name_from_backend_address
      # host_name = backend_http_settings.value.host_name
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listener
    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.protocol
      ssl_certificate_name           = http_listener.value.ssl_certificate_name
    }
  }

  ssl_certificate {
    name                = var.certificate_name
    key_vault_secret_id = data.azurerm_key_vault_certificate.keyvaultcertificateinfo.secret_id
  }

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rule
    content {
      name                       = request_routing_rule.value.name
      rule_type                  = request_routing_rule.value.rule_type
      http_listener_name         = request_routing_rule.value.http_listener_name
      backend_address_pool_name  = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name = request_routing_rule.value.backend_http_settings_name
      url_path_map_name          = request_routing_rule.value.url_path_map_name
      priority                   = request_routing_rule.value.priority
    }
  }

  dynamic "probe" {
    for_each = var.probe
    content {
      name                                      = probe.value.name
      protocol                                  = probe.value.protocol
      path                                      = probe.value.path
      host                                      = probe.value.host
      interval                                  = probe.value.interval
      timeout                                   = probe.value.timeout
      unhealthy_threshold                       = probe.value.unhealthy_threshold
      pick_host_name_from_backend_http_settings = probe.value.pick_host_name_from_backend_http_settings
    }
  }

  dynamic "url_path_map" {
    for_each = var.url_path_map
    content {
      name                               = url_path_map.value.name
      default_backend_address_pool_name  = url_path_map.value.default_backend_address_pool_name
      default_backend_http_settings_name = url_path_map.value.default_backend_http_settings_name

      dynamic "path_rule" {
        for_each = url_path_map.value.path_rules
        content {
          name                       = path_rule.value.name
          paths                      = path_rule.value.paths
          backend_address_pool_name  = path_rule.value.backend_address_pool_name
          backend_http_settings_name = path_rule.value.backend_http_settings_name
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [gateway_ip_configuration]
  }
}


# resource "azurerm_monitor_diagnostic_setting" "application_gateway" {
#   count = length(var.diagnostic_log_analytics_workspaces)

#   name                       = "${var.name}-appgw-diag"
#   log_analytics_workspace_id = var.diagnostic_log_analytics_workspaces[count.index].id
#   target_resource_id         = azurerm_application_gateway.appgw.id

#   dynamic "log" {
#     for_each = [for cat, sta in var.diagnostic_log_analytics_workspaces[count.index] : [cat, sta] if cat == "ApplicationGatewayAccessLog" || cat == "ApplicationGatewayPerformanceLog" || cat == "ApplicationGatewayFirewallLog"]
#     content {
#       category = log.value[0]
#       enabled  = log.value[1]
#     }
#   }
#   metric {
#     category = "AllMetrics"

#   }
# }

data "azurerm_network_interface" "vm_nic" {
  for_each            = var.vm_nic
  name                = each.value.network_interface_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "appgw_backend_association" {
  for_each              = var.vm_nic
  network_interface_id  = data.azurerm_network_interface.vm_nic[each.key].id
  ip_configuration_name = "ipconfig1"
  #backend_address_pool_id = azurerm_application_gateway.appgw.backend_address_pool[0].id
  backend_address_pool_id = one([
    for pool in azurerm_application_gateway.appgw.backend_address_pool[*] : pool.id
    if pool.name == each.value.backend_pool_name
  ])

}

# resource "azurerm_monitor_diagnostic_setting" "nsg_diagnostics" {
#   count                      = length(var.diagnostic_log_analytics_workspaces)
#   name                       = "${var.name}-appgw-nsg-diag"
#   log_analytics_workspace_id = var.diagnostic_log_analytics_workspaces[count.index].id
#   target_resource_id         = azurerm_network_security_group.appgw_nsg.id
#   storage_account_id         = var.log_analytics_storage_account_id

#   dynamic "enabled_log" {
#     for_each = var.log_analytics_nsg_diag_categories
#     content {
#       category = enabled_log.value

#     }
#   }
# }