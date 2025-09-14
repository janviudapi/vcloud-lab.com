variable "name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

# variable "spoke_count" {
#   description = "count"
#   type        = string
# }

# variable "prefix" {
#   description = "prefix"
#   type        = string
# }

# variable "environment" {
#   description = "Environment (dev, test, prod)"
#   type        = string
# }



# variable "allowed_ip_addresses" {
#   description = "List of allowed IP addresses for the Key Vault network ACLs"
#   type        = list(string)
# }

variable "runner_ip" {
  description = "IP address of the runner"
  type        = bool
  default     = false
}

variable "key_vault_admin_password_secret_name" {
  description = "Name of the secret in the key vault for the admin password"
  type        = string

}
variable "key_vault_admin_username_secret_name" {
  description = "Name of the secret in the key vault for the admin username"
  type        = string

}
variable "sku_kv" {
  description = "(Optional) The Name of the SKU used for this Key Vault. Possible values are standard and premium. Default is standard."
  type        = string
  default     = "standard"

  validation {
    condition     = can(regex("^(standard|premium)$", var.sku_kv))
    error_message = "SKU can only be standard or premium."
  }
}

# variable "enabled_for_deployment" {
#   description = "(Optional) Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. Default is false."
#   type        = bool
#   default     = false
# }

# variable "enabled_for_disk_encryption" {
#   description = "(Optional) Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Default is false."
#   type        = bool
#   default     = false
# }

# variable "enabled_for_template_deployment" {
#   description = "(Optional) Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. Default is false."
#   type        = bool
#   default     = false
# }

# variable "enable_rbac_authorization" {
#   description = "(Optional) Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. Default is false."
#   type        = bool
#   default     = false
# }

variable "network_acls" {
  description = "(Optional) A network_acls block as defined by https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault#network_acls."
  type = object({
    bypass                     = optional(string, "None")
    default_action             = optional(string, "Deny")
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  default = {}
}
variable "purge_protection_enabled" {
  description = "(Optional) Is Purge Protection enabled for this Key Vault? Defaults to true."
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "(Optional) Whether public network access is allowed for this Key Vault. Defaults to false."
  type        = bool
  default     = false
}

variable "soft_delete_retention_days" {
  description = "(Optional) The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days."
  type        = number
  default     = 90
}

# variable "access_policies" {
#   description = "(Optional) A access policy as defined by https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy. Only used if enable_rbac_authorization is false."
#   type = list(object({
#     object_id               = string
#     #application_id          = optional(string, null)
#     certificate_permissions = optional(list(string), [])
#     key_permissions         = optional(list(string), [])
#     secret_permissions      = optional(list(string), [])
#     storage_permissions     = optional(list(string), [])
#   }))
#   default = []
# }

# variable "role_assignments" {
#   description = "(Optional) If enable_rbac_authorization=true this can be used to assign Azure built-in roles for Key Vault (see https://learn.microsoft.com/azure/key-vault/general/rbac-guide?tabs=azure-cli#azure-built-in-roles-for-key-vault-data-plane-operations)."
#   type = list(object({
#     role_definition_name = string
#     principal_id         = string
#   }))
#   default = []

#   validation {
#     condition = length([
#       for assignment in var.role_assignments : true
#       if contains([
#         "Key Vault Administrator",
#         "Key Vault Certificates Officer",
#         "Key Vault Crypto Officer",
#         "Key Vault Crypto Service Encryption User",
#         "Key Vault Crypto User",
#         "Key Vault Reader",
#         "Key Vault Secrets Officer",
#         "Key Vault Secrets User"
#       ], assignment.role_definition_name)
#     ]) == length(var.role_assignments)
#     error_message = "Only Azure built-in roles for Key Vault can be used (see https://learn.microsoft.com/azure/key-vault/general/rbac-guide?tabs=azure-cli#azure-built-in-roles-for-key-vault-data-plane-operations)."
#   }
# }

# variable "log_analytics_workspace_id" {
#   description = "(Optional) ID of an existing Log Analytics Workspace to send diagnostic data to. If left empty, not diagnostic settings are configured."
#   type        = string
#   default     = null
# }

# variable "log_analytics_storage_account_id" {
#   description = "ID of the Storage Account for the Log Analytics Workspace."
#   type        = string
#   default     = null
# }

# variable "log_analytics_workspace_enable_logs" {
#   description = "Enable diagnostic logs. If true, requires Workspace ID and Storage Account ID to be set."
#   type        = bool
#   default     = false
# }

# variable "version_suffix" {
#   description = "Version suffix for the Key Vault name (e.g., 'v1')."
#   type        = string
#   default     = "v1" # Default to 'v1' if not specified
# }