data "azurerm_client_config" "subscriptioninfo" {}

# data "azurerm_subnet" "frontendsubnetinfo" {
#   name                 = var.network_info.subnet_name
#   virtual_network_name = var.network_info.virtual_network_name
#   resource_group_name  = var.network_info.resource_group_name
# }

# data "azurerm_subnet" "backendsubnetinfo" {
#   name                 = var.network_info.subnet_name
#   virtual_network_name = var.network_info.virtual_network_name
#   resource_group_name  = var.network_info.resource_group_name
# }

data "azurerm_subnet" "appgw_subnet_info" {
  name                 = var.network_info.subnet_name
  virtual_network_name = var.network_info.virtual_network_name
  resource_group_name  = var.resource_group_name
}

# data "azurerm_user_assigned_identity" "useridentityinfo" {
#   name                = var.user_assigned_identity_info.name
#   resource_group_name = var.user_assigned_identity_info.resource_group_name
# }

data "azurerm_key_vault" "keyvaultinfo" {
  name                = var.key_vault_info.name
  resource_group_name = var.resource_group_name
}

# data "azurerm_key_vault_secret" "keyvaultsecretinfo" {
#   name         =  "certpassword" #var.key_vault_info.secret_name
#   key_vault_id = data.azurerm_key_vault.keyvaultinfo.id
# }

# data "azurerm_key_vault_certificate" "keyvaultcertificateinfo" {
#   name         = var.key_vault_info.certificate_name
#   key_vault_id = data.azurerm_key_vault.keyvaultinfo.id
# }

data "azurerm_network_interface" "vm_nic" {
  for_each            = var.vm_nic
  name                = each.value.network_interface_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_key_vault_certificate" "testcert" {
  name         = var.certificate_name
  key_vault_id = data.azurerm_key_vault.keyvaultinfo.id

  certificate {
    contents = filebase64("../_certs/${var.certificate_name}.pfx")
    password = base64decode("dUUwM2JWMTVjYzJxZ1ZLRQ==") #var.encrypted_certificate_password #"uE03bV15cc2qgVKE"
  }
}