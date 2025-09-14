resource "azurerm_network_interface" "networkinterace" {
  name                = "nic-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "ipconfig1" #"${var.name}-ipconfig"
    subnet_id                     = data.azurerm_subnet.subnetinfo.id
    private_ip_address_allocation = "Static" #"Dynamic"
    private_ip_address            = var.private_ip_address
    private_ip_address_version    = "IPv4"
  }

  tags = var.tags
}

resource "azurerm_user_assigned_identity" "vm_identity" {
  name                = "uai-${var.key_vault_info.secret_name}"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_windows_virtual_machine" "windowsvirtualmachine" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  size                       = var.size
  admin_username             = var.admin_username
  admin_password             = data.azurerm_key_vault_secret.keyvaultsecretinfo.value #var.admin_password #"Computer@123"
  network_interface_ids      = [azurerm_network_interface.networkinterace.id]
  zone                       = var.zone
  enable_automatic_updates   = true
  patch_mode                 = "AutomaticByOS"
  encryption_at_host_enabled = false

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.vm_identity.id] # data.azurerm_key_vault_secret.userassignedidentityinfo.value
  }

  os_disk {
    caching              = var.os_disk.caching              #"ReadWrite"
    storage_account_type = var.os_disk.storage_account_type #"Standard_LRS"
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  custom_data = base64encode(templatefile("${path.module}/templates/user_data.tpl", {
    rdp_enabled     = var.rdp_enabled
    init_powershell = var.init_powershell
  }))

  tags = var.tags
}

# resource "azurerm_virtual_machine_extension" "virtualmachineextension" {
#   name                 = "${var.name}-vmext"
#   virtual_machine_id   = azurerm_windows_virtual_machine.windowsvirtualmachine.id
#   publisher            = "Microsoft.Compute"
#   type                 = "CustomScriptExtension"
#   type_handler_version = "1.10"

#   depends_on = [azurerm_virtual_machine_data_disk_attachment.data_disk_attach]

#   settings = jsonencode({
#     "fileUris" : var.ext_settings.fileUris,
#     "commandToExecute" : var.ext_settings.commandToExecute
#   })

#   # # # # # # # # example - working - 0 -2 - start
#   # settings = jsonencode({
#   #   "fileUris" : var.ext_settings.fileUris,
#   #   "commandToExecute" : var.ext_settings.commandToExecute
#   # })
#   # # # # # # # # example - 0 -2 - end

#   # # # # # # # # example - 0 -1 - start
#   #  settings = jsonencode({
#   #     script = file("_scripts/ConfigureRemotingForAnsible.ps1")
#   #     #commandtoexecute = "powershell -ExecutionPolicy Unrestricted -File ConfigureRemotingForAnsible.ps1"
#   #   })
#   # # # # # # # # example - 0 -1 - end

#   # # # # # # # # example - 0 0 - start
#   # settings = <<SETTINGS
#   # {
#   #   "fileUris": ["https://sadevspoke001.blob.core.windows.net/scripts/ConfigureRemotingForAnsible.ps1"],
#   #   "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File ConfigureRemotingForAnsible.ps1"
#   # }
#   # SETTINGS
#   # # # # # # # # example - 0 0 - end

#   # # # # # # # # example - 0 1 - start
#   # settings = <<SETTINGS
#   #   {
#   #       "script": "${file("${path.module}/script.ps1")}"
#   #   }
#   # SETTINGS
#   # # # # # # # # example - 0 1 - end

#   # # # # # # # # example - 0 2 - start
#   #     settings = <<SETTINGS
#   #     {
#   #         "fileUris": ["https://sadevspoke001.blob.core.windows.net/postdeploystuff/winrm.ps1"]
#   #     }
#   # SETTINGS
#   #   protected_settings = <<PROTECTED_SETTINGS
#   #     {
#   #       "commandToExecute": "powershell -ExecutionPolicy Unrestricted -NoProfile -NonInteractive -File winrm.ps1",
#   #       #"storageAccountName": "mystorageaccountname",
#   #       #"storageAccountKey": "xxxxx"
#   #     }
#   #   PROTECTED_SETTINGS
#   # # # # # # # # example - 0 2 - end
# }

#creates a data disk to be attached to the VM
resource "azurerm_managed_disk" "data_disk" {
  for_each             = { for disk in var.data_disks : disk.lun => disk }
  name                 = "${var.name}-disk-${each.key}"
  create_option        = "Empty"
  location             = azurerm_windows_virtual_machine.windowsvirtualmachine.location
  resource_group_name  = azurerm_windows_virtual_machine.windowsvirtualmachine.resource_group_name
  zone                 = var.zone
  tags                 = var.tags
  storage_account_type = each.value.storage_account_type
  disk_size_gb         = each.value.disk_size_gb
  lifecycle {
    ignore_changes = [encryption_settings]
  }
}
#attached the disk previously created to the VM
resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attach" {
  for_each           = { for disk in var.data_disks : disk.lun => disk }
  caching            = each.value.caching
  lun                = each.value.lun
  managed_disk_id    = azurerm_managed_disk.data_disk[each.key].id
  virtual_machine_id = azurerm_windows_virtual_machine.windowsvirtualmachine.id
}