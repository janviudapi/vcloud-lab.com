data "azurerm_virtual_machine" "virtualmachineinfo" {
  name                = var.virtual_machine_name
  resource_group_name = var.resource_group_name
}

data "azurerm_recovery_services_vault" "recoveryservicesvaultinfo" {
  name                = var.recovery_services_vault_name
  resource_group_name = var.resource_group_name
}

data "azurerm_backup_policy_vm" "backuppolicyinfo" {
  name                = var.backup_policy_name
  resource_group_name = var.resource_group_name
  recovery_vault_name = var.recovery_services_vault_name
}