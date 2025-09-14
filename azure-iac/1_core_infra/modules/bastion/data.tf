data "azurerm_subnet" "subnetinfo" {
  name                 = "AzureBastionSubnet"
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}