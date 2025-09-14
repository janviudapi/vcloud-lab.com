output "uploadtostorageaccountinfo" {
  value = {
    name                           = azurerm_storage_account.storageaccount.name
    id                             = azurerm_storage_account.storageaccount.id
    container_id                   = azurerm_storage_container.storagecontainer.id
    blob_ids                       = { for k, v in azurerm_storage_blob.storageblob : k => v.id }
    storage_container_endpoint_url = "${azurerm_storage_account.storageaccount.primary_blob_endpoint}${azurerm_storage_container.storagecontainer.name}/"
  }
}

output "container_endpoint_url" {
  value = "${azurerm_storage_account.storageaccount.primary_blob_endpoint}${azurerm_storage_container.storagecontainer.name}/"
}

output "blob_urls" {
  value = {
    for k, v in azurerm_storage_blob.storageblob :
    k => "${azurerm_storage_account.storageaccount.primary_blob_endpoint}${azurerm_storage_container.storagecontainer.name}/${v.name}"
  }
}
