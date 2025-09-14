resource "azurerm_backup_protected_vm" "vm1" {
  resource_group_name = var.resource_group_name
  recovery_vault_name = var.recovery_services_vault_name
  source_vm_id        = data.azurerm_virtual_machine.virtualmachineinfo.id
  backup_policy_id    = data.azurerm_backup_policy_vm.backuppolicyinfo.id
}