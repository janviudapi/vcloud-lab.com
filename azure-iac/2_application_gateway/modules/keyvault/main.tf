resource "azurerm_key_vault" "vault" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.sku_kv
  # enable_rbac_authorization       = var.enable_rbac_authorization
  # enabled_for_deployment          = var.enabled_for_deployment
  # enabled_for_template_deployment = var.enabled_for_template_deployment
  # enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  soft_delete_retention_days    = var.soft_delete_retention_days
  purge_protection_enabled      = var.purge_protection_enabled
  public_network_access_enabled = var.public_network_access_enabled

  network_acls {
    bypass                     = var.network_acls.bypass
    default_action             = var.network_acls.default_action
    ip_rules                   = (var.network_acls.ip_rules == null || var.runner_ip == true) || (var.network_acls.ip_rules != null && var.runner_ip == false) ? concat(var.network_acls.ip_rules, [local.runner_ip]) : []
    virtual_network_subnet_ids = var.network_acls.virtual_network_subnet_ids
  }

  lifecycle {
    ignore_changes = [network_acls]
  }
}

resource "azurerm_key_vault_access_policy" "default_vault_access_policy" {
  key_vault_id = azurerm_key_vault.vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id
  #application_id          = each.value.application_id
  certificate_permissions = [
    "Get",
    "List",
    "Create",
    "Update",
    "Import",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "Recover",
    "Purge"
  ]
  key_permissions = [
    "Get",
    "List",
    "Create",
    "Update",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "GetRotationPolicy",
    "SetRotationPolicy",
    "Rotate",
    "Purge",
    "Sign",
    "Verify",
    "WrapKey",
    "UnwrapKey",
    "Encrypt",
    "Decrypt"
  ]
  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
  ]
  storage_permissions = [
    "Get",
    "List",
    "Delete",
    "Set",
    "Update",
    "RegenerateKey",
    "Recover",
    "Backup",
    "Restore",
    "Purge"
  ]
}

# resource "azurerm_key_vault_access_policy" "vault_access_policy" {
#   for_each = { for policy in var.access_policies : policy.object_id => policy }

#   key_vault_id            = azurerm_key_vault.vault.id
#   tenant_id               = data.azurerm_client_config.current.tenant_id
#   object_id               = each.value.object_id
#   application_id          = each.value.application_id
#   certificate_permissions = each.value.certificate_permissions
#   key_permissions         = each.value.key_permissions
#   secret_permissions      = each.value.secret_permissions
#   storage_permissions     = each.value.storage_permissions

#   depends_on = [ azurerm_key_vault.vault, azurerm_key_vault_access_policy.default_vault_access_policy ]
# }

# resource "azurerm_role_assignment" "vault_role_assignment" {
#   for_each = { for assignment in var.role_assignments : "${assignment.principal_id}->${assignment.role_definition_name}" => assignment }

#   scope                = azurerm_key_vault.vault.id
#   role_definition_name = each.value.role_definition_name
#   principal_id         = each.value.principal_id
# }

# resource "azurerm_monitor_diagnostic_setting" "vault_diagnostic" {
#   count = var.log_analytics_workspace_enable_logs == true ? 1 : 0

#   name                       = "kv-diagnostic-${local.name_pattern}"
#   target_resource_id         = azurerm_key_vault.vault.id
#   log_analytics_workspace_id = var.log_analytics_workspace_id
#   storage_account_id         = var.log_analytics_storage_account_id
#   enabled_log {
#     category_group = "allLogs"
#   }

#   metric {
#     category = "AllMetrics"
#   }
# }

resource "random_password" "vm_password" {
  length      = 16
  special     = true
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}


resource "azurerm_key_vault_secret" "vm_username" {
  depends_on      = [azurerm_key_vault_access_policy.default_vault_access_policy] #, azurerm_role_assignment.vault_role_assignment
  name            = var.key_vault_admin_username_secret_name
  value           = "vmadmin"
  key_vault_id    = azurerm_key_vault.vault.id
  content_type    = "username"
  expiration_date = timeadd(timestamp(), "13140h")
  lifecycle {
    ignore_changes = [value, expiration_date]
  }
}

resource "azurerm_key_vault_secret" "vm_password" {
  depends_on = [azurerm_key_vault_access_policy.default_vault_access_policy] #, azurerm_role_assignment.vault_role_assignment
  name       = var.key_vault_admin_password_secret_name
  value      = random_password.vm_password.result
  #value           = "VmAdm!n@1234"
  key_vault_id    = azurerm_key_vault.vault.id
  content_type    = "password"
  expiration_date = timeadd(timestamp(), "13140h") # 18 months #"2026-12-27T00:00:00Z"
  lifecycle {
    ignore_changes = [value, expiration_date]
  }
}
# get ip of runner for allowed ip
data "http" "runner_ip" { url = "https://api.ipify.org/?format=json" }

# Parse the IP address from the response 
locals {
  runner_ip = (jsondecode(data.http.runner_ip.response_body)["ip"])
  # name_pattern       = "${lower(var.prefix)}-${lower(var.environment)}-${var.spoke_count}"
  # short_name_pattern = "ctc-${lower(var.environment)}-${var.spoke_count}${var.version_suffix}"
}
