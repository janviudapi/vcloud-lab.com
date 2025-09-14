data "azurerm_subnet" "subnetinfo" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_key_vault" "keyvaultinfo" {
  name                = var.key_vault_info.name
  resource_group_name = var.key_vault_info.resource_group_name
}

data "azurerm_key_vault_secret" "keyvaultsecretinfo" {
  name         = var.key_vault_info.secret_name
  key_vault_id = data.azurerm_key_vault.keyvaultinfo.id
}

# data "azurerm_key_vault_secret" "userassignedidentityinfo" {
#   name         = "userassignedidentity" #var.key_vault_info.secret_name
#   key_vault_id = data.azurerm_key_vault.keyvaultinfo.id
# }

