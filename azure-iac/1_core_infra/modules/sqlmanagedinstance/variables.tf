variable "resource_group_name" {
  description = "The name of the existing Resource Group"
  type        = string
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
}

variable "sql_mi_name" {
  description = "The name of the Azure SQL Managed Instance"
  type        = string
}

variable "sku_name" {
  description = "The SKU for the SQL Managed Instance (e.g., GP_Gen5_2)"
  type        = string
}

variable "storage_account_type" {
  description = "Storage account type"
  type        = string

}

variable "storage_size" {
  description = "Storage size in GB (e.g., 32, 64, 128)"
  type        = number
}

variable "vcores" {
  description = "Number of vCores"
  type        = number

}

variable "vnet_name" {
  description = "The name of the existing Virtual Network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the existing Subnet for SQL Managed Instance"
  type        = string
}

variable "key_vault_name" {
  description = "The name of the existing Azure Key Vault"
  type        = string
}

variable "key_vault_admin_user_secret_name" {
  description = "The name of the Key Vault secret containing the SQL MI admin username"
  type        = string
}

variable "key_vault_admin_pass_secret_name" {
  description = "The name of the Key Vault secret containing the SQL MI admin password"
  type        = string
}

variable "license_type" {
  description = "License type for SQL MI"
  type        = string

}

variable "collation" {
  description = "Collation for SQL MI"
  type        = string

}

variable "private_dns_zone_name" {
  description = "The name of the Private DNS Zone"
  type        = string

}

variable "private_dns_zone_virtual_network_link_name" {
  description = "The name of the Private DNS Zone Virtual Network Link"
  type        = string

}

variable "subresource_names" {
  description = "The names of the subresources"
  type        = list(string)

}