output "private_ip_addresses" {
  description = "Private IPs of the virtual machines"
  value       = azurerm_network_interface.networkinterace.private_ip_address
}
