resource "azurerm_network_interface" "networkinterace" {
  name                = "${var.name}-nic"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "${var.name}-ipconfig"
    subnet_id                     = data.azurerm_subnet.subnetinfo.id
    private_ip_address_allocation = "Static" #"Dynamic"
    private_ip_address            = var.private_ip_address
    private_ip_address_version    = "IPv4"
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "linuxvirtualmachine" {
  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = var.size
  admin_username                  = var.admin_username
  admin_password                  = data.azurerm_key_vault_secret.keyvaultsecretinfo.value #var.admin_password
  network_interface_ids           = [azurerm_network_interface.networkinterace.id]
  disable_password_authentication = false

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

  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.userassignedidentityinfo.id]
  }

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "virtualmachineextension" {
  name                 = "${var.name}-vmext"
  virtual_machine_id   = azurerm_linux_virtual_machine.linuxvirtualmachine.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"


  settings = jsonencode({
    "fileUris" : var.ext_settings.fileUris,
    "commandToExecute" : var.ext_settings.commandToExecute
  })

  timeouts {
    create = "60m" # Set creation timeout to 60 minutes
    update = "60m" # Set update timeout to 60 minutes
    read   = "60m" # Set read timeout to 60 minutes
    delete = "60m" # Set deletion timeout to 60 minutes
  }

  # # # # # # # # example - 0 -1 - start
  #  settings = jsonencode({
  #     script = file("_scripts/ConfigureRemotingForAnsible.ps1")
  #     #commandtoexecute = "powershell -ExecutionPolicy Unrestricted -File ConfigureRemotingForAnsible.ps1"
  #   })
  # # # # # # # # example - 0 -1 - end

  # # # # # # # # example - 0 0 - start
  # settings = <<SETTINGS
  # {
  #   "fileUris": ["https://vcloudlabdemo01scripts.blob.core.windows.net/scripts/ConfigureRemotingForAnsible.ps1"],
  #   "commandToExecute": "powershell -ExecutionPolicy Unrestricted -File ConfigureRemotingForAnsible.ps1"
  # }
  # SETTINGS
  # # # # # # # # example - 0 0 - end

  # # # # # # # # example - 0 1 - start
  # settings = <<SETTINGS
  #   {
  #       "script": "${file("${path.module}/script.ps1")}"
  #   }
  # SETTINGS
  # # # # # # # # example - 0 1 - end

  # # # # # # # # example - 0 2 - start
  #     settings = <<SETTINGS
  #     {
  #         "fileUris": ["https://mystorageaccountname.blob.core.windows.net/postdeploystuff/winrm.ps1"]
  #     }
  # SETTINGS
  #   protected_settings = <<PROTECTED_SETTINGS
  #     {
  #       "commandToExecute": "powershell -ExecutionPolicy Unrestricted -NoProfile -NonInteractive -File winrm.ps1",
  #       #"storageAccountName": "mystorageaccountname",
  #       #"storageAccountKey": "xxxxx"
  #     }
  #   PROTECTED_SETTINGS
  # # # # # # # # example - 0 2 - end
}