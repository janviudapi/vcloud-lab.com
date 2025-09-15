module "application_gateway" {
  source                         = "../modules/applicationgateway"
  for_each                       = { for applicationgateway in var.application_gateway_info : applicationgateway.name => applicationgateway }
  name                           = each.value.name
  resource_group_name            = each.value.resource_group_name
  location                       = each.value.location
  public_ip_allocation_method    = each.value.public_ip_allocation_method
  public_ip_sku_appg             = each.value.public_ip_sku_appg
  private_ip                     = each.value.private_ip
  zones                          = each.value.zones
  network_info                   = each.value.network_info
  sku                            = each.value.sku
  frontend_port                  = each.value.frontend_port
  backend_address_pool           = each.value.backend_address_pool
  vm_nic                         = each.value.vm_nic
  backend_http_settings          = each.value.backend_http_settings
  http_listener                  = each.value.http_listener
  request_routing_rule           = each.value.request_routing_rule
  probe                          = each.value.probe
  url_path_map                   = each.value.url_path_map
  # nsg_rules                      = each.value.nsg_rules
  key_vault_info                 = each.value.key_vault_info
  certificate_name               = each.value.certificate_name
  encrypted_certificate_password = base64decode(each.value.encrypted_certificate_password)
  #route                       = each.value.route
  #next_hop_in_ip_address      = each.value.next_hop_in_ip_address  
  # diagnostic_log_analytics_workspaces = [{ 
  #   id = module.monitoring.log_analytics_workspace_id, ApplicationGatewayAccessLog = true
  #   ApplicationGatewayPerformanceLog = true
  #   ApplicationGatewayFirewallLog = true 
  # }]
  # depends_on = [module.key_vault] #module.windows_virtual_machine, module.virtual_network,
}

# module "key_vault" {
#   source              = "../modules/keyvault"
#   name                = var.keyvault_info.name
#   resource_group_name = var.keyvault_info.resource_group_name
#   location            = var.keyvault_info.location
#   sku_kv              = var.keyvault_info.sku_kv
#   #access_policies                      = var.keyvault_info.access_policies
#   #role_assignments                     = var.keyvault_info.role_assignments
#   network_acls                         = var.keyvault_info.network_acls
#   runner_ip                            = var.keyvault_info.runner_ip
#   public_network_access_enabled        = var.keyvault_info.public_network_access_enabled
#   purge_protection_enabled             = var.keyvault_info.purge_protection_enabled
#   key_vault_admin_username_secret_name = var.keyvault_info.key_vault_admin_username_secret_name
#   key_vault_admin_password_secret_name = var.keyvault_info.key_vault_admin_password_secret_name
#   soft_delete_retention_days           = var.keyvault_info.soft_delete_retention_days
# } 