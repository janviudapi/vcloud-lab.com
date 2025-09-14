data "azurerm_subscription" "subscriptioninfo" {}

data "azurerm_resource_group" "rginfo" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "vnetinfo" {
  name                = var.virtual_network_name
  resource_group_name = data.azurerm_resource_group.rginfo.name
}

data "azurerm_subnet" "subnetinfo" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.rginfo.name
  virtual_network_name = data.azurerm_virtual_network.vnetinfo.name
}