resource_group_info = [
  {
    name     = "rg-dev-hub-001"
    location = "eastus"
    tags = {
      environment = "dev"
      project     = "demo-001"
    }
  },
  {
    name     = "rg-dev-spoke-001"
    location = "eastus"
    tags = {
      environment = "dev"
      project     = "demo-001"
    }
  }
]

virtual_network_info = [
  {
    name                = "vnet-dev-hub-001"
    resource_group_name = "rg-dev-hub-001"
    address_space       = ["10.1.0.0/16"]
    tags = {
      environment = "dev"
      project     = "demo-001"
    }
  },
  {
    name                = "vnet-dev-spoke-001"
    resource_group_name = "rg-dev-spoke-001"
    address_space       = ["10.2.0.0/16"]
    tags = {
      environment = "dev"
      project     = "demo-001"
    }
  }
]

subnet_info = [
  {
    name                 = "snet-hubvnet001-hub-fw-001"
    virtual_network_name = "vnet-dev-hub-001"
    address_space        = ["10.1.1.0/24"]
    location             = "eastus"
    nsg_rules = [
      {
        name                       = "AllowAppgatewayInbound"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "65200-65535"
        source_address_prefix      = "GatewayManager"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowAppgatewayOutbound"
        priority                   = 100
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "65200-65535"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "App-GW-Inbound-Https"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "App-GW-Inbound-Custom-Ports"
        priority                   = 102
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges    = ["8089", "30066", "30077", "8090"]
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
    tags = {
      environment = "dev"
      project     = "demo-001"
    }
  },
  {
    name                 = "snet-spokevnet001-web-tier-001"
    virtual_network_name = "vnet-dev-spoke-001"
    address_space        = ["10.2.1.0/24"]
    location             = "eastus"
    nsg_rules = [
      {
        name                       = "Allow-RDP-Inbound"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Allow-HTTP-Inbound"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Inbound-Traffic-TCP-Subnets"
        priority                   = 102
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        source_address_prefixes    = ["10.124.28.64/26", "10.124.28.128/26", "10.124.28.208/28", "10.131.166.0/24"]
        destination_address_prefix = "10.124.28.192/28"
        destination_port_ranges    = ["7001", "8080", "30001", "1999", "2001", "443", "80", "22", "8088", "15389", "8083", "8082", "1433", "8983", "9090", "8086", "30066", "8090", "8089", "55566", "1433", "2888", "3888", "2181", "5000", "3000", "4544", "8443", "8086", "8087"]
      },
      {
        name                       = "Allow-ICMP"
        priority                   = 103
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Icmp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Inbound-Traffic-UDP-Subnets"
        priority                   = 104
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Udp"
        source_port_range          = "*"
        source_address_prefixes    = ["10.124.28.208/28"]
        destination_address_prefix = "10.124.28.192/28"
        destination_port_ranges    = ["29000", "28001", "3000", "4544", "8087", "30002", "30077", "57093"]
      }
    ]
    tags = {
      environment = "dev"
      project     = "demo-001"
    }
  },
  {
    name                 = "snet-spokevnet001-ent-tier-001"
    virtual_network_name = "vnet-dev-spoke-001"
    address_space        = ["10.2.2.0/24"]
    location             = "eastus"
    nsg_rules = [
      {
        name                       = "Allow-RDP-Inbound"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "3389"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Allow-HTTPS-Inbound"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Inbound-Traffic-TCP-Subnets"
        priority                   = 102
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        source_address_prefixes    = ["10.124.28.64/26", "10.124.28.128/26", "10.124.28.192/28", "10.131.166.0/24"]
        destination_address_prefix = "10.124.28.208/28"
        destination_port_ranges = ["7001", "8080", "30001", "1999", "2001", "443", "80", "22", "8088", "15389", "8083", "8082", "1433", "8983", "9090", "8086", "30066", "8090", "8089", "55566", "1433", "2888", "3888", "2181", "5000", "3000", "4544", "8443", "8086", "8087"
        ]
      },
      {
        name                       = "Allow-ICMP"
        priority                   = 103
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Icmp"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "Inbound-Traffic-UDP-Subnets"
        priority                   = 104
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Udp"
        source_port_range          = "*"
        source_address_prefixes    = ["10.124.28.192/28"]
        destination_address_prefix = "10.124.28.208/28"
        destination_port_ranges    = ["29000", "28001", "3000", "4544", "8087", "30002", "30077", "57093"]
      }
    ]
    tags = {
      environment = "dev"
      project     = "demo-001"
    }
  },
  {
    name                 = "snet-spokevnet001-pvendpoint-001"
    virtual_network_name = "vnet-dev-spoke-001"
    address_space        = ["10.2.3.0/24"]
    location             = "eastus"
    nsg_rules = [
      {
        name                       = "AllowAppgatewayInbound"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "65200-65535"
        source_address_prefix      = "GatewayManager"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowAppgatewayOutbound"
        priority                   = 100
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "65200-65535"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "App-GW-Inbound-Https"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "App-GW-Inbound-Custom-Ports"
        priority                   = 102
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges    = ["8089", "30066", "30077", "8090"]
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
    tags = {
      environment = "dev"
      project     = "demo-001"
    }
  },
  {
    name                 = "AzureBastionSubnet"
    virtual_network_name = "vnet-dev-spoke-001"
    address_space        = ["10.2.4.0/24"]
    location             = "eastus"
    tags = {
      environment = "dev"
      project     = "demo-001"
    }
  },
  {
    name                 = "ApplicationGatewaySubnet"
    virtual_network_name = "vnet-dev-spoke-001"
    address_space        = ["10.2.5.0/24"]
    location             = "eastus"
    nsg_rules = [
      {
        name                       = "AllowAppgatewayInbound"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "65200-65535"
        source_address_prefix      = "GatewayManager"
        destination_address_prefix = "*"
      },
      {
        name                       = "AllowAppgatewayOutbound"
        priority                   = 100
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "65200-65535"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "App-GW-Inbound-Https"
        priority                   = 101
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      },
      {
        name                       = "App-GW-Inbound-Custom-Ports"
        priority                   = 102
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges    = ["8089", "30066", "30077", "8090"]
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
    tags = {
      environment = "dev"
      project     = "demo-001"
    }
  },
  {
    name                 = "snet-spokevnet001-sqlmi-001"
    virtual_network_name = "vnet-dev-spoke-001"
    address_space        = ["10.2.6.0/24"]
    location             = "eastus"
    nsg_rules = [
      {
        name                       = "allow_tds_inbound"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "1433"
        source_address_prefix      = "VirtualNetwork"
        destination_address_prefix = "*"
      }
    ]
    tags = {
      environment = "dev"
      project     = "demo-001"
    }
  }

]

vnet_peering_info = [
  {
    name                      = "hub001todevspoke001"
    resource_group_name       = "rg-dev-hub-001"
    virtual_network_name      = "vnet-dev-hub-001"
    remote_virtual_network_id = "vnet-dev-spoke-001"
  },
  {
    name                      = "devspoke001tohub001"
    resource_group_name       = "rg-dev-spoke-001"
    virtual_network_name      = "vnet-dev-spoke-001"
    remote_virtual_network_id = "vnet-dev-hub-001"
  }
]

bastion_host_info = [
  {
    name                 = "spokebastionhost"
    resource_group_name  = "rg-dev-spoke-001"
    virtual_network_name = "vnet-dev-spoke-001"
    tags = {
      environment = "dev"
      project     = "demo-001"
    }
  }
]

upload_to_storage_account_info = [
  {
    name                     = "sadevspoke001"
    resource_group_name      = "rg-dev-spoke-001"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    tags = {
      environment = "dev"
      project     = "demo-001"
    }
  }
]

keyvault_info = {
  name                = "kv-dev-spoke-001"
  resource_group_name = "rg-dev-spoke-001"
  location            = "East US"
  sku_kv              = "standard"
  network_acls = {
    bypass         = "AzureServices"
    default_action = "Allow"
  }
  public_network_access_enabled        = true
  purge_protection_enabled             = false
  key_vault_admin_username_secret_name = "vm-admin-username"
  key_vault_admin_password_secret_name = "vm-admin-password"
  soft_delete_retention_days           = 7
  runner_ip                            = false
}

data_disks = [
  {
    lun          = 2
    disk_size_gb = 128
  }
]

windows_virtual_machine_info = [
  {
    name                 = "vm-dev-web-001"
    resource_group_name  = "rg-dev-spoke-001"
    virtual_network_name = "vnet-dev-spoke-001"
    subnet_name          = "snet-spokevnet001-web-tier-001"
    vm_size              = "Standard_B2s"
    admin_username       = "vmadmin"
    private_ip_address          = "10.2.1.5"
    user_assigned_identity_name = "vm-dev-web-001"
    key_vault_info = {
      name                = "kv-dev-spoke-001"
      secret_name         = "vm-admin-password"
      resource_group_name = "rg-dev-spoke-001"
    }
    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }
    # ext_settings = {
    #   fileUris = [
    #     "https://sadevspoke001.blob.core.windows.net/scripts/ConfigureRemotingForAnsible.ps1"
    #   ]
    #   commandToExecute = "powershell -ExecutionPolicy Unrestricted -File ConfigureRemotingForAnsible.ps1"
    # }
    tags = {
      environment = "dev"
      project     = "demo-001"
    }
  },
  {
    name                 = "vm-dev-ent-001"
    resource_group_name  = "rg-dev-spoke-001"
    virtual_network_name = "vnet-dev-spoke-001"
    subnet_name          = "snet-spokevnet001-ent-tier-001"
    vm_size              = "Standard_B2s"
    admin_username       = "vmadmin"
    private_ip_address          = "10.2.2.5"
    user_assigned_identity_name = "vm-dev-ent-001"
    key_vault_info = {
      name                = "kv-dev-spoke-001"
      secret_name         = "vm-admin-password"
      resource_group_name = "rg-dev-spoke-001"
    }
    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }
    # ext_settings = {
    #   fileUris = [
    #     "https://sadevspoke001.blob.core.windows.net/scripts/ConfigureRemotingForAnsible.ps1"
    #   ]
    #   commandToExecute = "powershell -ExecutionPolicy Unrestricted -File ConfigureRemotingForAnsible.ps1"
    # }
    tags = {
      environment = "dev"
      project     = "demo-001"
    }
  },
  {
    name                 = "vm-dev-ent-002"
    resource_group_name  = "rg-dev-spoke-001"
    virtual_network_name = "vnet-dev-spoke-001"
    subnet_name          = "snet-spokevnet001-ent-tier-001"
    vm_size              = "Standard_B2s"
    admin_username       = "vmadmin"
    private_ip_address          = "10.2.2.6"
    user_assigned_identity_name = "vm-dev-ent-002"
    key_vault_info = {
      name                = "kv-dev-spoke-001"
      secret_name         = "vm-admin-password"
      resource_group_name = "rg-dev-spoke-001"
    }
    os_disk = {
      caching              = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }
    source_image_reference = {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2019-Datacenter"
      version   = "latest"
    }
    # ext_settings = {
    #   fileUris = [
    #     "https://sadevspoke001.blob.core.windows.net/scripts/ConfigureRemotingForAnsible.ps1"
    #   ]
    #   commandToExecute = "powershell -ExecutionPolicy Unrestricted -File ConfigureRemotingForAnsible.ps1"
    # }
    tags = {
      environment = "dev"
      project     = "demo-001"
    }
  }
]

# linux_virtual_machine_info = [
#   {
#     name                 = "vm-dev-ansible-001"
#     resource_group_name  = "rg-dev-spoke-001"
#     virtual_network_name = "vnet-dev-spoke-001"
#     subnet_name          = "snet-spokevnet001-web-tier-001"
#     vm_size              = "Standard_B2s"
#     admin_username       = "vmadmin"
#     private_ip_address = "10.2.1.6"
#     key_vault_info = {
#       name                = "kv-dev-spoke-001"
#       secret_name         = "vm-admin-password"
#       resource_group_name = "rg-dev-spoke-001"
#     }
#     os_disk = {
#       caching              = "ReadWrite"
#       storage_account_type = "Standard_LRS"
#     }
#     source_image_reference = {
#       publisher = "Canonical"
#       offer     = "0001-com-ubuntu-server-jammy"
#       sku       = "22_04-lts"
#       version   = "latest"
#     }
#     ext_settings = {
#       fileUris = [
#         "https://sadevspoke001.blob.core.windows.net/scripts/installansible.sh"
#       ]
#       commandToExecute = "sh installansible.sh"
#     }
#     identity = {
#       resource_group_name         = "rg-dev-spoke-001"
#       user_assigned_identity_name = "dev"
#     }
#     tags = {
#       environment = "dev"
#       project     = "demo-001"
#     }
#   }
# ]

# application_gateway_info = [
#   {
#     name                        = "rg-dev-appgw-001"
#     resource_group_name         = "rg-dev-spoke-001"
#     location                    = "East US"
#     public_ip_allocation_method = "Static"
#     public_ip_sku_appg          = "Standard"
#     private_ip                  = "10.2.5.5"
#     zones                       = [1, 2, 3]

#     network_info = {
#       subnet_name          = "ApplicationGatewaySubnet"
#       virtual_network_name = "vnet-dev-spoke-001"
#     }

#     sku = {
#       name     = "Standard_v2"
#       tier     = "Standard_v2"
#       capacity = 2
#     }
#     frontend_port = [
#       {
#         name = "port80"
#         port = 80
#       },
#       {
#         name = "port443"
#         port = 443
#       }
#     ]
#     backend_address_pool = [
#       {
#         name         = "backendpool-ent-tcda001"
#         ip_addresses = ["10.2.2.5"] # Use only the private IPs assigned to virtual machines
#       },
#       {
#         name         = "backendpool-ent-tcdv001"
#         ip_addresses = ["10.2.2.6"] # Use only the private IPs assigned to virtual machines
#       },
#       {
#         name         = "backendpool-web-tcdw001"
#         ip_addresses = ["10.2.1.5"] # Use only the private IPs assigned to virtual machines

#       }
#     ]
#     vm_nic = {
#       tcda001 = { network_interface_name = "nic-vm-dev-ent-001", backend_pool_name = "backendpool-ent-tcda001" },
#       tcdv001 = { network_interface_name = "nic-vm-dev-ent-002", backend_pool_name = "backendpool-ent-tcdv001" },
#       tcdw001 = { network_interface_name = "nic-vm-dev-web-001", backend_pool_name = "backendpool-web-tcdw001" }
#     }

#     backend_http_settings = [
#       {
#         name                  = "tc"
#         cookie_based_affinity = "Disabled"
#         #path                                = "/"
#         port            = 7001
#         protocol        = "Http"
#         request_timeout = 7200
#         #probe_name                          = "appgw-backendpool-tc" -- need to update here
#         pick_host_name_from_backend_address = false
#         #host_name                           = "10.124.28.197" # webtier host of tomcat
#       },
#       {
#         name                  = "tcawc"
#         cookie_based_affinity = "Disabled"
#         #path                                = "/"
#         port            = 3000
#         protocol        = "Http"
#         request_timeout = 7200
#         #probe_name                          = "appgw-backendpool-aw"
#         pick_host_name_from_backend_address = false
#         #host_name                           = "10.124.28.213" # awc server of tc

#       },

#       {
#         name                  = "fsc"
#         cookie_based_affinity = "Disabled"
#         path                  = "/"
#         port                  = 4544
#         protocol              = "Http"
#         request_timeout       = 14000
#         #host_name                           = "10.124.28.214" # vol server of tc
#         pick_host_name_from_backend_address = false
#         probe_name                          = "appgw-backendpool-aw"
#         #pick_host_name_from_backend_address = true    
#         #  override_with_specific_domain_name  = number  ##############################  need to verify before apply
#       },
#       {
#         name                  = "tcvisadmin"
#         cookie_based_affinity = "Disabled"
#         #path                                = "/"
#         port            = 8089
#         protocol        = "Http"
#         request_timeout = 180
#         #host_name                           = "10.124.28.213" # vol server of tc
#         pick_host_name_from_backend_address = false
#       },

#       {
#         name                  = "tcvisassigner"
#         cookie_based_affinity = "Disabled"
#         #path                                = "/"
#         port            = 3000
#         protocol        = "Http"
#         request_timeout = 60
#         #host_name                           = "10.124.28.213" # vol server of tc
#         pick_host_name_from_backend_address = false
#       }
#     ]

#     http_listener = [
#       # {
#       #   name                           = "appgw-backendpool-http"
#       #   frontend_port_name             = "port80"
#       #   frontend_ip_configuration_name = "fip-pvip-appgw-composabletc-prod-001"
#       #   protocol                       = "Http"
#       # ssl_certificate_name = null },
#       {
#         name                           = "appgw-backendpool-https"
#         frontend_ip_configuration_name = "fip-pvip-appgw-rg-dev-appgw-001"
#         frontend_port_name             = "port443"
#         protocol                       = "Https"
#         ssl_certificate_name           = "testcert"
#       }
#     ]
#     request_routing_rule = [
#       {
#         name                       = "appgw-backendpool-routing"
#         rule_type                  = "PathBasedRouting"
#         http_listener_name         = "appgw-backendpool-https"
#         backend_address_pool_name  = "backendpool-ent-tcda001"
#         backend_http_settings_name = "tcawc"
#         url_path_map_name          = "path-map-1"
#         priority                   = 901
#       }
#     ]
#     probe = [
#       {
#         name                                      = "appgw-backendpool-aw"
#         protocol                                  = "Http"
#         path                                      = "/"
#         interval                                  = 30
#         timeout                                   = 30
#         unhealthy_threshold                       = 3
#         pick_host_name_from_backend_http_settings = false
#         host                                      = "10.124.28.214"
#         match = {
#           status_code = ["200-400"]
#           body        = "HTTP ERROR 400 MISSING_TICKET_0"
#         }
#         #backend_settings = "fsc"
#       }
#     ]

#     url_path_map = [
#       {
#         name                               = "path-map-1"
#         default_backend_address_pool_name  = "backendpool-ent-tcda001"
#         default_backend_http_settings_name = "tcawc"
#         path_rules = [
#           {
#             name                       = "tc"
#             paths                      = ["/tc*"]
#             backend_address_pool_name  = "backendpool-ent-tcda001"
#             backend_http_settings_name = "tcawc"
#           },
#           {
#             name                       = "tcjsonrestservice1"
#             paths                      = ["/tc/JsonRestServices*"]
#             backend_address_pool_name  = "backendpool-ent-tcda001"
#             backend_http_settings_name = "tcawc"
#           },
#           {
#             name                       = "tsslog"
#             paths                      = ["/tss-logservice/*"]
#             backend_address_pool_name  = "backendpool-web-tcdw001"
#             backend_http_settings_name = "tc"
#           },
#           {
#             name                       = "tssids"
#             paths                      = ["/tss-idservice/*"]
#             backend_address_pool_name  = "backendpool-web-tcdw001"
#             backend_http_settings_name = "tc"
#           },
#           {
#             name                       = "micro"
#             paths                      = ["/micro/*"]
#             backend_address_pool_name  = "backendpool-ent-tcda001"
#             backend_http_settings_name = "tcawc"
#           },
#           {
#             name                       = "assets"
#             paths                      = ["/assets/*"]
#             backend_address_pool_name  = "backendpool-ent-tcda001"
#             backend_http_settings_name = "tcawc"
#           },
#           {
#             name                       = "tcaw"
#             paths                      = ["/awc/*"]
#             backend_address_pool_name  = "backendpool-ent-tcda001"
#             backend_http_settings_name = "tcawc"
#           },
#           {
#             name                       = "fmsupload"
#             paths                      = ["/fms/fmsupload*"]
#             backend_address_pool_name  = "backendpool-ent-tcdv001"
#             backend_http_settings_name = "fsc"
#           },
#           {
#             name                       = "fmsdownload"
#             paths                      = ["/fmsdownload/*"]
#             backend_address_pool_name  = "backendpool-ent-tcdv001"
#             backend_http_settings_name = "fsc"
#           },
#           {
#             name                       = "fsc"
#             paths                      = ["/tc/fms/-1664225600*"]
#             backend_address_pool_name  = "backendpool-ent-tcdv001"
#             backend_http_settings_name = "fsc"
#           },
#           {
#             name                       = "staticjs"
#             paths                      = ["/static/js*"]
#             backend_address_pool_name  = "backendpool-ent-tcda001"
#             backend_http_settings_name = "tcawc"
#           },
#           {
#             name                       = "visadmin"
#             paths                      = ["/VisProxyServlet/admin*"]
#             backend_address_pool_name  = "backendpool-ent-tcdv001"
#             backend_http_settings_name = "tcvisadmin"
#           },
#           {
#             name                       = "visproxy"
#             paths                      = ["/VisProxyServlet*"]
#             backend_address_pool_name  = "backendpool-ent-tcdv001"
#             backend_http_settings_name = "tcvisadmin"
#           }
#         ]
#       }
#     ]

#     "nsg_rules" = [
#       {
#         name                       = "AllowAppgatewayInbound"
#         priority                   = 100
#         direction                  = "Inbound"
#         access                     = "Allow"
#         protocol                   = "Tcp"
#         source_port_range          = "*"
#         destination_port_range     = "65200-65535"
#         source_address_prefix      = "GatewayManager"
#         destination_address_prefix = "*"
#       },
#       {
#         name                       = "AllowAppgatewayOutbound"
#         priority                   = 100
#         direction                  = "Outbound"
#         access                     = "Allow"
#         protocol                   = "Tcp"
#         source_port_range          = "*"
#         destination_port_range     = "65200-65535"
#         source_address_prefix      = "*"
#         destination_address_prefix = "*"
#       },
#       {
#         name                       = "App-GW-Inbound-Https"
#         priority                   = 101
#         direction                  = "Inbound"
#         access                     = "Allow"
#         protocol                   = "Tcp"
#         source_port_range          = "*"
#         destination_port_range     = "443"
#         source_address_prefix      = "*"
#         destination_address_prefix = "*"
#       },
#       {
#         name                       = "App-GW-Inbound-Custom-Ports"
#         priority                   = 102
#         direction                  = "Inbound"
#         access                     = "Allow"
#         protocol                   = "Tcp"
#         source_port_range          = "*"
#         destination_port_ranges    = ["8089", "30066", "30077", "8090"]
#         source_address_prefix      = "*"
#         destination_address_prefix = "*"
#       }
#     ]


#     route = [
#       { name = "onprem1", address_prefix = "10.124.0.0/16" },
#       { name = "onprem2", address_prefix = "10.16.0.0/16" }
#     ]

#     #next_hop_in_ip_address = "10.13.18.71" #HUB firewal IP
#     key_vault_info = {
#       name             = "sadevspoke001"
#       certificate_name = "testcert"
#     }
#     certificate_name = "testcert"


#     user_assigned_identity_info = {
#       name                = "dev"
#       resource_group_name = "rg-dev-spoke-001"
#     }

#     tags = {
#       environment = "dev"
#       project     = "demo-001"
#     }
#   }
# ]

storage_account_with_ep_info = [
  {
    name                     = "devlabfileshare01" #vcloudlabfileshare01
    resource_group_name      = "rg-dev-spoke-001"
    account_kind             = "StorageV2"
    account_tier             = "Standard"
    account_replication_type = "LRS"
    virtual_network_name     = "vnet-dev-spoke-001"
    subnet_name              = "snet-spokevnet001-pvendpoint-001"
    tags = {
      environment = "dev"
      project     = "demo-001"
    }
  }
]

private_dns_zone_info = [
  {
    name                 = "blob"
    resource_group_name  = "rg-dev-spoke-001"
    virtual_network_name = "vnet-dev-spoke-001"
  },
  {
    name                 = "file"
    resource_group_name  = "rg-dev-spoke-001"
    virtual_network_name = "vnet-dev-spoke-001"
  }
]
#https://learn.microsoft.com/en-us/azure/storage/common/storage-private-endpoints

# recovery_services_vault_info = [
#   {
#     name                = "spokerecoveryvault"
#     resource_group_name = "rg-dev-spoke-001"
#     location            = "eastus"
#     sku                 = "Standard"
#     soft_delete_enabled = false
#     backup_policy = {
#       name     = "WinVMBackupPolicy" # cannot be named DefaultPolicy
#       timezone = "UTC"
#       backup = {
#         frequency = "Daily"
#         time      = "23:00"
#       }
#       retention_daily = {
#         count = 10
#       }
#       retention_weekly = {
#         count    = 42
#         weekdays = ["Sunday", "Wednesday", "Friday", "Saturday"]
#       }
#       retention_monthly = {
#         count    = 7
#         weekdays = ["Sunday", "Wednesday"]
#         weeks    = ["First", "Last"]
#       }
#       retention_yearly = {
#         count    = 77
#         weekdays = ["Sunday"]
#         weeks    = ["Last"]
#         months   = ["January"]
#       }
#     }
#   }
# ]

# backup_virtual_machine_info = [
#   {
#     virtual_machine_name         = "spokevm001"
#     resource_group_name          = "rg-dev-spoke-001"
#     recovery_services_vault_name = "spokerecoveryvault"
#     backup_policy_name           = "WinVMBackupPolicy"
#   },
#   {
#     virtual_machine_name         = "spokevm002"
#     resource_group_name          = "rg-dev-spoke-001"
#     recovery_services_vault_name = "spokerecoveryvault"
#     backup_policy_name           = "WinVMBackupPolicy"
#   }
# ]

# backup_virtual_machine_info = [
#   {
#     virtual_machine_name         = "vm-dev-web-001"
#     resource_group_name          = "rg-dev-spoke-001"
#     recovery_services_vault_name = "spokerecoveryvault"
#     backup_policy_name           = "WinVMBackupPolicy"
#   },
#   {
#     virtual_machine_name         = "vm-dev-ent-001"
#     resource_group_name          = "rg-dev-spoke-001"
#     recovery_services_vault_name = "spokerecoveryvault"
#     backup_policy_name           = "WinVMBackupPolicy"
#   },
#   {
#     virtual_machine_name         = "vm-dev-ent-002"
#     resource_group_name          = "rg-dev-spoke-001"
#     recovery_services_vault_name = "spokerecoveryvault"
#     backup_policy_name           = "WinVMBackupPolicy"
#   }
# ]