variable "virtual_machine_name" {
  description = "The name of the virtual machine"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "recovery_services_vault_name" {
  description = "The name of the recovery services vault"
  type        = string
}

variable "backup_policy_name" {
  description = "The name of the backup policy"
  type        = string
}