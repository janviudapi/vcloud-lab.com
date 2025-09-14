resource "azurerm_recovery_services_vault" "recoveryservicevault" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  soft_delete_enabled = var.soft_delete_enabled
}

resource "azurerm_backup_policy_vm" "example" {
  name                = var.backup_policy.name
  resource_group_name = var.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.recoveryservicevault.name
  timezone            = var.backup_policy.timezone

  backup {
    frequency = var.backup_policy.backup.frequency
    time      = var.backup_policy.backup.time
  }

  retention_daily {
    count = var.backup_policy.retention_daily.count
  }

  retention_weekly {
    count    = var.backup_policy.retention_weekly.count
    weekdays = var.backup_policy.retention_weekly.weekdays
  }

  retention_monthly {
    count    = var.backup_policy.retention_monthly.count
    weekdays = var.backup_policy.retention_monthly.weekdays
    weeks    = var.backup_policy.retention_monthly.weeks
  }

  retention_yearly {
    count    = var.backup_policy.retention_yearly.count
    weekdays = var.backup_policy.retention_yearly.weekdays
    weeks    = var.backup_policy.retention_yearly.weeks
    months   = var.backup_policy.retention_yearly.months
  }
}