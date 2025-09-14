resource "azurerm_private_dns_zone" "privatednszone" {
  name                = "privatelink.${var.name}.core.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_zone_vnet_link" {
  name                  = "${var.name}-private-dns-zone-vnet-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.privatednszone.name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
}