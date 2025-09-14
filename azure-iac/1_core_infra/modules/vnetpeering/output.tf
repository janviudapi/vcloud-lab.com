output "virtualnetworkpeeringinfo" {
  value = {
    name                      = azurerm_virtual_network_peering.virtualnetworkpeering.name
    resource_group_name       = azurerm_virtual_network_peering.virtualnetworkpeering.resource_group_name
    virtual_network_name      = azurerm_virtual_network_peering.virtualnetworkpeering.virtual_network_name
    remote_virtual_network_id = azurerm_virtual_network_peering.virtualnetworkpeering.remote_virtual_network_id
    id                        = azurerm_virtual_network_peering.virtualnetworkpeering.id
  }
}