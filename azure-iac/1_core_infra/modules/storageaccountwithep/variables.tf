variable "name" {
  description = "The name of the storage account."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the storage account."
  type        = string
}

variable "location" {
  description = "The location/region where the storage account should be created."
  type        = string
}

variable "account_kind" {
  description = "The Kind of the storage account to be created."
  type        = string
}

variable "account_tier" {
  description = "The Tier of the storage account to be created."
  type        = string
}

variable "account_replication_type" {
  description = "The Replication type of the storage account to be created."
  type        = string
}

variable "virtual_network_name" {
  description = "The name of the virtual network in which to create the storage account."
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet in which to create the storage account."
  type        = string
}

variable "private_service_connections" {
  description = "A map of DNS records to create based on the storage account kind"
  type        = map(any)
  default = {
    storagev2   = ["blob", "file"]
    blobstorage = ["blob"]
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}