output "subnetinfo" {
  value = {
    name                 = azurerm_subnet.subnet.name
    resource_group_name  = azurerm_subnet.subnet.resource_group_name
    virtual_network_name = azurerm_subnet.subnet.virtual_network_name
    address_prefixes     = azurerm_subnet.subnet.address_prefixes
    id                   = azurerm_subnet.subnet.id
  }
}