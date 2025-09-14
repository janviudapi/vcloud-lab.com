variable "name" {
  description = "Name of the storage account"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Location of the resource group"
  type        = string
}

variable "account_tier" {
  description = "Tier of the storage account"
  type        = string
}

# variable "folderpath" {
#   description = "Folder Path of the scripts"
#   type        = string
# }

variable "account_replication_type" {
  description = "Replication type of the storage account"
  type        = string
}

variable "tags" {
  description = "Tags of the storage account"
  type        = map(string)
}
