resource "azurerm_storage_account" "storageaccount" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  tags                     = var.tags
}

resource "azurerm_storage_container" "storagecontainer" {
  name                  = "scripts"
  storage_account_id    = azurerm_storage_account.storageaccount.id
  container_access_type = "blob"
}

resource "azurerm_storage_blob" "storageblob" {
  for_each = fileset("../_scripts", "*") #for_each = fileset("_scripts", "*") #for_each = fileset("${path.module}/_scripts", "*")

  name                   = trim(each.key, "/")
  storage_account_name   = azurerm_storage_account.storageaccount.name
  storage_container_name = azurerm_storage_container.storagecontainer.name
  type                   = "Block"
  source                 = "../_scripts/${each.key}" #"_scripts/${each.key}" #"${path.module}/_scripts/${each.key}"
}

resource "azurerm_role_assignment" "roleassignment" {
  scope                = azurerm_storage_account.storageaccount.id
  role_definition_name = "Storage Blob Data Contributor"              # Can also be "Storage Blob Data Owner", etc.
  principal_id         = data.azurerm_client_config.current.object_id # Replace with the appropriate principal ID
}