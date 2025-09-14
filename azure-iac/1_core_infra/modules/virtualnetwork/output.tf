output "virtualnetworkinfo" {
  value = {
    name                = azurerm_virtual_network.virtualnetwork.name
    resource_group_name = azurerm_virtual_network.virtualnetwork.resource_group_name
    location            = azurerm_virtual_network.virtualnetwork.location
    address_space       = azurerm_virtual_network.virtualnetwork.address_space
    tags                = azurerm_virtual_network.virtualnetwork.tags
    id                  = azurerm_virtual_network.virtualnetwork.id
  }
}