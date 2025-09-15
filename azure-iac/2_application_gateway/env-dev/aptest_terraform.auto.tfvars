application_gateway_info = [
  {
    name                        = "rg-dev-appgw-001"
    resource_group_name         = "rg-dev-spoke-001"
    location                    = "East US"
    public_ip_allocation_method = "Static"
    public_ip_sku_appg          = "Standard"
    private_ip                  = "10.2.5.5"
    zones                       = [1, 2, 3]

    network_info = {
      subnet_name          = "ApplicationGatewaySubnet"
      virtual_network_name = "vnet-dev-spoke-001"
    }

    sku = {
      name     = "Standard_v2"
      tier     = "Standard_v2"
      capacity = 2
    }
    frontend_port = [
      {
        name = "port80"
        port = 80
      },
      {
        name = "port443"
        port = 443
      }
    ]
    backend_address_pool = [
      {
        name         = "backendpool-ent-tcda001"
        ip_addresses = ["10.2.2.15"] # Use only the private IPs assigned to virtual machines
      },
      {
        name         = "backendpool-ent-tcdv001"
        ip_addresses = ["10.2.2.16"] # Use only the private IPs assigned to virtual machines
      },
      {
        name         = "backendpool-web-tcdw001"
        ip_addresses = ["10.2.1.15"] # Use only the private IPs assigned to virtual machines

      }
    ]
    vm_nic = {
      tcda001 = { network_interface_name = "nic-vm-dev-ent-001", backend_pool_name = "backendpool-ent-tcda001" },
      tcdv001 = { network_interface_name = "nic-vm-dev-ent-002", backend_pool_name = "backendpool-ent-tcdv001" },
      tcdw001 = { network_interface_name = "nic-vm-dev-web-001", backend_pool_name = "backendpool-web-tcdw001" }
    }

    backend_http_settings = [
      {
        name                  = "tc"
        cookie_based_affinity = "Disabled"
        #path                                = "/"
        port            = 7001
        protocol        = "Http"
        request_timeout = 7200
        #probe_name                          = "appgw-backendpool-tc" -- need to update here
        pick_host_name_from_backend_address = false
        #host_name                           = "10.124.28.197" # webtier host of tomcat
      },
      {
        name                  = "tcawc"
        cookie_based_affinity = "Disabled"
        #path                                = "/"
        port            = 3000
        protocol        = "Http"
        request_timeout = 7200
        #probe_name                          = "appgw-backendpool-aw"
        pick_host_name_from_backend_address = false
        #host_name                           = "10.124.28.213" # awc server of tc

      },

      {
        name                  = "fsc"
        cookie_based_affinity = "Disabled"
        path                  = "/"
        port                  = 4544
        protocol              = "Http"
        request_timeout       = 14000
        #host_name                           = "10.124.28.214" # vol server of tc
        pick_host_name_from_backend_address = false
        probe_name                          = "appgw-backendpool-aw"
        #pick_host_name_from_backend_address = true    
        #  override_with_specific_domain_name  = number  ##############################  need to verify before apply
      },
      {
        name                  = "tcvisadmin"
        cookie_based_affinity = "Disabled"
        #path                                = "/"
        port            = 8089
        protocol        = "Http"
        request_timeout = 180
        #host_name                           = "10.124.28.213" # vol server of tc
        pick_host_name_from_backend_address = false
      },

      {
        name                  = "tcvisassigner"
        cookie_based_affinity = "Disabled"
        #path                                = "/"
        port            = 3000
        protocol        = "Http"
        request_timeout = 60
        #host_name                           = "10.124.28.213" # vol server of tc
        pick_host_name_from_backend_address = false
      }
    ]

    http_listener = [
      # {
      #   name                           = "appgw-backendpool-http"
      #   frontend_port_name             = "port80"
      #   frontend_ip_configuration_name = "fip-pvip-appgw-composabletc-prod-001"
      #   protocol                       = "Http"
      # ssl_certificate_name = null },
      {
        name                           = "appgw-backendpool-https"
        frontend_ip_configuration_name = "fip-pvip-appgw-rg-dev-appgw-001"
        frontend_port_name             = "port443"
        protocol                       = "Https"
        ssl_certificate_name           = "testcert"
      }
    ]
    request_routing_rule = [
      {
        name                       = "appgw-backendpool-routing"
        rule_type                  = "PathBasedRouting"
        http_listener_name         = "appgw-backendpool-https"
        backend_address_pool_name  = "backendpool-ent-tcda001"
        backend_http_settings_name = "tcawc"
        url_path_map_name          = "path-map-1"
        priority                   = 901
      }
    ]
    probe = [
      {
        name                                      = "appgw-backendpool-aw"
        protocol                                  = "Http"
        path                                      = "/"
        interval                                  = 30
        timeout                                   = 30
        unhealthy_threshold                       = 3
        pick_host_name_from_backend_http_settings = false
        host                                      = "10.124.28.214"
        match = {
          status_code = ["200-400"]
          body        = "HTTP ERROR 400 MISSING_TICKET_0"
        }
        #backend_settings = "fsc"
      }
    ]

    url_path_map = [
      {
        name                               = "path-map-1"
        default_backend_address_pool_name  = "backendpool-ent-tcda001"
        default_backend_http_settings_name = "tcawc"
        path_rules = [
          {
            name                       = "tc"
            paths                      = ["/tc*"]
            backend_address_pool_name  = "backendpool-ent-tcda001"
            backend_http_settings_name = "tcawc"
          },
          {
            name                       = "tcjsonrestservice1"
            paths                      = ["/tc/JsonRestServices*"]
            backend_address_pool_name  = "backendpool-ent-tcda001"
            backend_http_settings_name = "tcawc"
          },
          {
            name                       = "tsslog"
            paths                      = ["/tss-logservice/*"]
            backend_address_pool_name  = "backendpool-web-tcdw001"
            backend_http_settings_name = "tc"
          },
          {
            name                       = "tssids"
            paths                      = ["/tss-idservice/*"]
            backend_address_pool_name  = "backendpool-web-tcdw001"
            backend_http_settings_name = "tc"
          },
          {
            name                       = "micro"
            paths                      = ["/micro/*"]
            backend_address_pool_name  = "backendpool-ent-tcda001"
            backend_http_settings_name = "tcawc"
          },
          {
            name                       = "assets"
            paths                      = ["/assets/*"]
            backend_address_pool_name  = "backendpool-ent-tcda001"
            backend_http_settings_name = "tcawc"
          },
          {
            name                       = "tcaw"
            paths                      = ["/awc/*"]
            backend_address_pool_name  = "backendpool-ent-tcda001"
            backend_http_settings_name = "tcawc"
          },
          {
            name                       = "fmsupload"
            paths                      = ["/fms/fmsupload*"]
            backend_address_pool_name  = "backendpool-ent-tcdv001"
            backend_http_settings_name = "fsc"
          },
          {
            name                       = "fmsdownload"
            paths                      = ["/fmsdownload/*"]
            backend_address_pool_name  = "backendpool-ent-tcdv001"
            backend_http_settings_name = "fsc"
          },
          {
            name                       = "fsc"
            paths                      = ["/tc/fms/-1664225600*"]
            backend_address_pool_name  = "backendpool-ent-tcdv001"
            backend_http_settings_name = "fsc"
          },
          {
            name                       = "staticjs"
            paths                      = ["/static/js*"]
            backend_address_pool_name  = "backendpool-ent-tcda001"
            backend_http_settings_name = "tcawc"
          },
          {
            name                       = "visadmin"
            paths                      = ["/VisProxyServlet/admin*"]
            backend_address_pool_name  = "backendpool-ent-tcdv001"
            backend_http_settings_name = "tcvisadmin"
          },
          {
            name                       = "visproxy"
            paths                      = ["/VisProxyServlet*"]
            backend_address_pool_name  = "backendpool-ent-tcdv001"
            backend_http_settings_name = "tcvisadmin"
          }
        ]
      }
    ]

    # "nsg_rules" = [
    #   {
    #     name                       = "AllowAppgatewayInbound"
    #     priority                   = 100
    #     direction                  = "Inbound"
    #     access                     = "Allow"
    #     protocol                   = "Tcp"
    #     source_port_range          = "*"
    #     destination_port_range     = "65200-65535"
    #     source_address_prefix      = "GatewayManager"
    #     destination_address_prefix = "*"
    #   },
    #   {
    #     name                       = "AllowAppgatewayOutbound"
    #     priority                   = 100
    #     direction                  = "Outbound"
    #     access                     = "Allow"
    #     protocol                   = "Tcp"
    #     source_port_range          = "*"
    #     destination_port_range     = "65200-65535"
    #     source_address_prefix      = "*"
    #     destination_address_prefix = "*"
    #   },
    #   {
    #     name                       = "App-GW-Inbound-Https"
    #     priority                   = 101
    #     direction                  = "Inbound"
    #     access                     = "Allow"
    #     protocol                   = "Tcp"
    #     source_port_range          = "*"
    #     destination_port_range     = "443"
    #     source_address_prefix      = "*"
    #     destination_address_prefix = "*"
    #   },
    #   {
    #     name                       = "App-GW-Inbound-Custom-Ports"
    #     priority                   = 102
    #     direction                  = "Inbound"
    #     access                     = "Allow"
    #     protocol                   = "Tcp"
    #     source_port_range          = "*"
    #     destination_port_ranges    = ["8089", "30066", "30077", "8090"]
    #     source_address_prefix      = "*"
    #     destination_address_prefix = "*"
    #   }
    # ]

    route = [
      { name = "onprem1", address_prefix = "10.124.0.0/16" },
      { name = "onprem2", address_prefix = "10.16.0.0/16" }
    ]

    #next_hop_in_ip_address = "10.13.18.71" #HUB firewal IP
    key_vault_info = {
      name             = "kv-dev-spoke-001"
      certificate_name = "testcert"
    }
    certificate_name               = "testcert"
    encrypted_certificate_password = "WW91clBhc3N3b3Jk" # Base64 encoded password "YourPassword"


    user_assigned_identity_info = {
      name                = "dev"
      resource_group_name = "rg-dev-spoke-001"
    }

    tags = {
      environment = "apdev"
      project     = "apdemo-001"
    }
  }
]

# keyvault_info = {
#   name                = "kv-dev-spoke-001"
#   resource_group_name = "rg-dev-spoke-001"
#   location            = "East US"
#   sku_kv              = "standard"
#   network_acls = {
#     bypass         = "AzureServices"
#     default_action = "Allow"
#   }
#   public_network_access_enabled        = true
#   purge_protection_enabled             = false
#   key_vault_admin_username_secret_name = "vm-admin-username"
#   key_vault_admin_password_secret_name = "vm-admin-password"
#   soft_delete_retention_days           = 7
#   runner_ip                            = false
# }