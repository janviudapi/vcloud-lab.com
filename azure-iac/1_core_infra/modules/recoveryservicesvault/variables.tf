variable "name" {
  description = "The name of the recovery vault name"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which the recovery vault should be created"
  type        = string
}

variable "location" {
  description = "The location of the recovery vault"
  type        = string
}

variable "sku" {
  description = "The SKU of the recovery vault"
  type        = string
}

variable "soft_delete_enabled" {
  description = "Should soft delete be enabled for the recovery vault"
  type        = bool
}

variable "backup_policy" {
  description = "The backup policy to associate with the recovery vault"
  type = object({
    name     = string
    timezone = string
    backup = object({
      frequency = string
      time      = string
    })
    retention_daily = object({
      count = number
    })
    retention_weekly = object({
      count    = number
      weekdays = list(string)
    })
    retention_monthly = object({
      count    = number
      weekdays = list(string)
      weeks    = list(string)
    })
    retention_yearly = object({
      count    = number
      weekdays = list(string)
      weeks    = list(string)
      months   = list(string)
    })
  })
}