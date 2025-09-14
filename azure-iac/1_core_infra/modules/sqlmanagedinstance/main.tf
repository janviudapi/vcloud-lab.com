provider "azurerm" {
  features {}
}

# Fetch existing Resource Group
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# Fetch existing Virtual Network
data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
}

# Fetch existing Subnet
data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

# Fetch existing Key Vault
data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

# Fetch credentials from Key Vault
data "azurerm_key_vault_secret" "admin_username" {
  name         = var.key_vault_admin_user_secret_name
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_key_vault_secret" "admin_password" {
  name         = var.key_vault_admin_pass_secret_name
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

# Azure SQL Managed Instance
resource "azurerm_sql_managed_instance" "sqlmi" {
  name                         = var.sql_mi_name
  resource_group_name          = data.azurerm_resource_group.rg.name
  location                     = data.azurerm_resource_group.rg.location
  administrator_login          = data.azurerm_key_vault_secret.admin_username.value
  administrator_login_password = data.azurerm_key_vault_secret.admin_password.value
  license_type                 = var.license_type
  sku_name                     = var.sku_name
  storage_account_type         = var.storage_account_type
  storage_size_in_gb           = var.storage_size
  vcores                       = var.vcores
  collation                    = var.collation
  vnet_subnet_id               = data.azurerm_subnet.subnet.id
  public_data_endpoint_enabled = false
}

# Private DNS Zone
resource "azurerm_private_dns_zone" "dns_zone" {
  name                = var.private_dns_zone_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Private DNS Zone Virtual Network Link - Association
resource "azurerm_private_dns_zone_virtual_network_link" "dns_link" {
  name                  = var.private_dns_zone_virtual_network_link_name
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns_zone.name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
}

# Private Endpoint for SQL MI
resource "azurerm_private_endpoint" "private_endpoint" {
  name                = "${var.sql_mi_name}-pe"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "${var.sql_mi_name}-privatesc"
    private_connection_resource_id = azurerm_sql_managed_instance.sqlmi.id
    is_manual_connection           = false
    subresource_names              = var.subresource_names
  }
}

# Private DNS A Record for SQL MI
resource "azurerm_private_dns_a_record" "sqlmi_dns" {
  name                = azurerm_sql_managed_instance.sqlmi.name
  zone_name           = azurerm_private_dns_zone.dns_zone.name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.private_endpoint.private_service_connection.0.private_ip_address]
}
