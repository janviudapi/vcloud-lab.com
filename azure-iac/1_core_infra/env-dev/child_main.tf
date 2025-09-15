module "resource_group" {
  source   = "../modules/resourcegroup"
  for_each = { for resourcegroup in var.resource_group_info : resourcegroup.name => resourcegroup }

  name     = each.value.name
  location = each.value.location
  tags     = each.value.tags
}

module "virtual_network" {
  source   = "../modules/virtualnetwork"
  for_each = { for virtualnetwork in var.virtual_network_info : virtualnetwork.name => virtualnetwork }

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = module.resource_group[each.value.resource_group_name].resourcegroupinfo.location
  address_space       = each.value.address_space
  tags                = each.value.tags

  depends_on = [module.resource_group]
}

module "subnet" {
  source   = "../modules/subnet"
  for_each = { for subnet in var.subnet_info : subnet.name => subnet }

  name                 = each.value.name
  resource_group_name  = module.virtual_network[each.value.virtual_network_name].virtualnetworkinfo.resource_group_name
  location             = each.value.location
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_space
  nsg_rules            = each.value.nsg_rules
  depends_on           = [module.virtual_network]
}

module "vnet_peering" {
  source   = "../modules/vnetpeering"
  for_each = { for vnetpeering in var.vnet_peering_info : vnetpeering.name => vnetpeering }

  name                      = each.value.name
  resource_group_name       = each.value.resource_group_name
  virtual_network_name      = each.value.virtual_network_name
  remote_virtual_network_id = module.virtual_network[each.value.remote_virtual_network_id].virtualnetworkinfo.id

  depends_on = [module.virtual_network, module.subnet]
}

module "upload_to_storage_account" {
  source   = "../modules/uploadtostorageaccount"
  for_each = { for uploadtostorageaccount in var.upload_to_storage_account_info : uploadtostorageaccount.name => uploadtostorageaccount }

  name                     = each.value.name
  location                 = module.resource_group[each.value.resource_group_name].resourcegroupinfo.location
  resource_group_name      = each.value.resource_group_name
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type #"LRS" "ZRS" "GRS" "RAGRS" "GZRS" "RAGZRS"
  tags                     = each.value.tags
  depends_on               = [module.vnet_peering]
}

module "bastion_host" {
  source   = "../modules/bastion"
  for_each = { for bastion in var.bastion_host_info : bastion.name => bastion }

  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  location             = module.resource_group[each.value.resource_group_name].resourcegroupinfo.location
  virtual_network_name = each.value.virtual_network_name
  tags                 = each.value.tags
  depends_on           = [module.subnet]
}

module "windows_virtual_machine" {
  source   = "../modules/windowsvirtualmachine"
  for_each = { for windowsvirtualmachine in var.windows_virtual_machine_info : windowsvirtualmachine.name => windowsvirtualmachine }

  name                 = each.value.name
  location             = module.resource_group[each.value.resource_group_name].resourcegroupinfo.location
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  subnet_name          = each.value.subnet_name
  private_ip_address   = each.value.private_ip_address
  size                 = each.value.vm_size
  admin_username       = each.value.admin_username
  #admin_password       = each.value.admin_password
  rdp_enabled               = true
  user_assigned_identity_id = each.value.user_assigned_identity_name

  key_vault_info = {
    name                = each.value.key_vault_info.name                #"vcloudlab001"
    secret_name         = each.value.key_vault_info.secret_name         #"vmpassword"
    resource_group_name = each.value.key_vault_info.resource_group_name #"vcloud-lab.com"
  }

  os_disk = {
    caching              = each.value.os_disk.caching              #"ReadWrite"
    storage_account_type = each.value.os_disk.storage_account_type #"Standard_LRS"
  }

  source_image_reference = {
    publisher = each.value.source_image_reference.publisher #"MicrosoftWindowsServer"
    offer     = each.value.source_image_reference.offer     #"WindowsServer"
    sku       = each.value.source_image_reference.sku       #"2019-Datacenter"
    version   = each.value.source_image_reference.version   #"latest"
  }

  # ext_settings = {
  #   fileUris         = each.value.ext_settings.fileUris
  #   commandToExecute = each.value.ext_settings.commandToExecute
  # }

  data_disks = var.data_disks
  tags       = each.value.tags
  depends_on = [module.subnet, module.upload_to_storage_account, module.key_vault]
}

module "private_dns_zone" {
  source   = "../modules/privatednszone"
  for_each = { for privatednszone in var.private_dns_zone_info : privatednszone.name => privatednszone }

  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  depends_on           = [module.windows_virtual_machine]
}

module "storage_account_with_ep" {
  source   = "../modules/storageaccountwithep"
  for_each = { for storageaccountwithep in var.storage_account_with_ep_info : storageaccountwithep.name => storageaccountwithep }

  name                     = each.value.name
  resource_group_name      = each.value.resource_group_name
  location                 = module.resource_group[each.value.resource_group_name].resourcegroupinfo.location
  account_kind             = each.value.account_kind
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
  virtual_network_name     = each.value.virtual_network_name
  subnet_name              = each.value.subnet_name
  tags                     = each.value.tags
  depends_on               = [module.windows_virtual_machine, module.private_dns_zone]
}

module "key_vault" {
  source                               = "../modules/keyvault"
  name                                 = var.keyvault_info.name
  resource_group_name                  = var.keyvault_info.resource_group_name
  location                             = var.keyvault_info.location
  sku_kv                               = var.keyvault_info.sku_kv
  network_acls                         = var.keyvault_info.network_acls
  runner_ip                            = var.keyvault_info.runner_ip
  public_network_access_enabled        = var.keyvault_info.public_network_access_enabled
  purge_protection_enabled             = var.keyvault_info.purge_protection_enabled
  key_vault_admin_username_secret_name = var.keyvault_info.key_vault_admin_username_secret_name
  key_vault_admin_password_secret_name = var.keyvault_info.key_vault_admin_password_secret_name
  soft_delete_retention_days           = var.keyvault_info.soft_delete_retention_days
  #access_policies                      = var.keyvault_info.access_policies
  #role_assignments                     = var.keyvault_info.role_assignments
  depends_on = [module.resource_group, module.upload_to_storage_account]
}

# module "application_gateway" {
#   source                      = "../modules/applicationgateway"
#   for_each                    = { for applicationgateway in var.application_gateway_info : applicationgateway.name => applicationgateway }
#   name                        = each.value.name
#   resource_group_name         = each.value.resource_group_name
#   location                    = each.value.location
#   public_ip_allocation_method = each.value.public_ip_allocation_method
#   public_ip_sku_appg          = each.value.public_ip_sku_appg
#   private_ip                  = each.value.private_ip
#   zones                       = each.value.zones
#   network_info                = each.value.network_info
#   sku                         = each.value.sku
#   frontend_port               = each.value.frontend_port
#   backend_address_pool        = each.value.backend_address_pool
#   vm_nic                      = each.value.vm_nic
#   backend_http_settings       = each.value.backend_http_settings
#   http_listener               = each.value.http_listener
#   request_routing_rule        = each.value.request_routing_rule
#   probe                       = each.value.probe
#   url_path_map                = each.value.url_path_map
#   nsg_rules                   = each.value.nsg_rules
#   key_vault_info              = each.value.key_vault_info
#   certificate_name            = each.value.certificate_name
#   #route                       = each.value.route
#   #next_hop_in_ip_address      = each.value.next_hop_in_ip_address  
#   # diagnostic_log_analytics_workspaces = [{ 
#   #   id = module.monitoring.log_analytics_workspace_id, ApplicationGatewayAccessLog = true
#   #   ApplicationGatewayPerformanceLog = true
#   #   ApplicationGatewayFirewallLog = true 
#   # }]
#   depends_on = [module.windows_virtual_machine, module.virtual_network]
# }

# module "linux_virtual_machine" {
#   source   = "../modules/linuxvirtualmachine"
#   for_each = { for linuxvirtualmachine in var.linux_virtual_machine_info : linuxvirtualmachine.name => linuxvirtualmachine }

#   name                 = each.value.name
#   location             = module.resource_group[each.value.resource_group_name].resourcegroupinfo.location
#   resource_group_name  = each.value.resource_group_name
#   virtual_network_name = each.value.virtual_network_name
#   subnet_name          = each.value.subnet_name
#   private_ip_address   = each.value.private_ip_address
#   size                 = each.value.vm_size
#   admin_username       = each.value.admin_username
#   #admin_password       = each.value.admin_password

#   key_vault_info = {
#     name                = each.value.key_vault_info.name                #"vcloudlab001"
#     secret_name         = each.value.key_vault_info.secret_name         #"vmpassword"
#     resource_group_name = each.value.key_vault_info.resource_group_name #"vcloud-lab.com"
#   }

#   os_disk = {
#     caching              = each.value.os_disk.caching              #"ReadWrite"
#     storage_account_type = each.value.os_disk.storage_account_type #"Standard_LRS"
#   }

#   source_image_reference = {
#     publisher = each.value.source_image_reference.publisher #"MicrosoftWindowsServer"
#     offer     = each.value.source_image_reference.offer     #"WindowsServer"
#     sku       = each.value.source_image_reference.sku       #"2019-Datacenter"
#     version   = each.value.source_image_reference.version   #"latest"
#   }

#   ext_settings = {
#     fileUris         = each.value.ext_settings.fileUris
#     commandToExecute = each.value.ext_settings.commandToExecute
#   }

#   identity = {
#     resource_group_name         = each.value.identity.resource_group_name
#     user_assigned_identity_name = each.value.identity.user_assigned_identity_name
#   }

#   tags       = each.value.tags
#   depends_on = [module.windows_virtual_machine, module.storage_account_with_ep]
# }

# module "recovery_services_vault" {
#   source   = "../modules/recoveryservicesvault"
#   for_each = { for recoveryservicesvault in var.recovery_services_vault_info : recoveryservicesvault.name => recoveryservicesvault }

#   name                = each.value.name
#   resource_group_name = each.value.resource_group_name
#   location            = module.resource_group[each.value.resource_group_name].resourcegroupinfo.location
#   sku                 = each.value.sku
#   soft_delete_enabled = each.value.soft_delete_enabled

#   backup_policy = {
#     name     = each.value.backup_policy.name
#     timezone = each.value.backup_policy.timezone
#     backup = {
#       frequency = each.value.backup_policy.backup.frequency
#       time      = each.value.backup_policy.backup.time
#     }
#     retention_daily = {
#       count = each.value.backup_policy.retention_daily.count
#     }
#     retention_weekly = {
#       count    = each.value.backup_policy.retention_weekly.count
#       weekdays = each.value.backup_policy.retention_weekly.weekdays
#     }
#     retention_monthly = {
#       count    = each.value.backup_policy.retention_monthly.count
#       weekdays = each.value.backup_policy.retention_monthly.weekdays
#       weeks    = each.value.backup_policy.retention_monthly.weeks
#     }
#     retention_yearly = {
#       count    = each.value.backup_policy.retention_yearly.count
#       weekdays = each.value.backup_policy.retention_yearly.weekdays
#       weeks    = each.value.backup_policy.retention_yearly.weeks
#       months   = each.value.backup_policy.retention_yearly.months
#     }
#   }
#   depends_on = [module.resource_group, module.upload_to_storage_account, module.key_vault]
# }

# module "backup_virtual_machine" {
#   source   = "../modules/backupvirtualmachine"
#   for_each = { for backupvirtualmachine in var.backup_virtual_machine_info : backupvirtualmachine.virtual_machine_name => backupvirtualmachine }

#   virtual_machine_name         = each.value.virtual_machine_name
#   resource_group_name          = each.value.resource_group_name
#   recovery_services_vault_name = each.value.recovery_services_vault_name
#   backup_policy_name           = each.value.backup_policy_name
#   depends_on                   = [module.recovery_services_vault, module.windows_virtual_machine]
# }