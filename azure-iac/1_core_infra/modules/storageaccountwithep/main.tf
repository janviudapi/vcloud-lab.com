resource "azurerm_storage_account" "storageaccount" {
  name                          = var.name
  resource_group_name           = data.azurerm_resource_group.rginfo.name
  location                      = data.azurerm_resource_group.rginfo.location
  account_kind                  = var.account_kind
  account_tier                  = var.account_tier
  account_replication_type      = var.account_replication_type
  public_network_access_enabled = false
  tags                          = var.tags
}

locals {
  selected_private_endpoint = lookup(var.private_service_connections, lower(var.account_kind), [])
}

resource "azurerm_private_endpoint" "privateendpoint" {
  for_each                      = { for ep, connection in local.selected_private_endpoint : ep => connection }
  name                          = "${var.name}-ep-${each.value}"
  resource_group_name           = data.azurerm_resource_group.rginfo.name
  location                      = data.azurerm_resource_group.rginfo.location
  subnet_id                     = data.azurerm_subnet.subnetinfo.id
  custom_network_interface_name = "${var.name}-ep-${each.value}-nic"

  private_service_connection {
    name                           = "${var.name}-ep-${each.value}"
    private_connection_resource_id = resource.azurerm_storage_account.storageaccount.id
    subresource_names              = [each.value]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "${var.name}-ep-${each.value}-dns-zone-group"
    private_dns_zone_ids = ["/subscriptions/${data.azurerm_subscription.subscriptioninfo.subscription_id}/resourceGroups/${data.azurerm_resource_group.rginfo.name}/providers/Microsoft.Network/privateDnsZones/privatelink.${each.value}.core.windows.net"]
  }
}

resource "azurerm_storage_share" "storageaccountshare" {
  name               = "fileshare"
  storage_account_id = azurerm_storage_account.storageaccount.id
  quota              = 50
}