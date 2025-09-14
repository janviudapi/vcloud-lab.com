output "resourcegroupinfo" {
  value = {
    name     = azurerm_resource_group.resourcegroup.name
    location = azurerm_resource_group.resourcegroup.location
    tags     = azurerm_resource_group.resourcegroup.tags
    id       = azurerm_resource_group.resourcegroup.id
  }
}