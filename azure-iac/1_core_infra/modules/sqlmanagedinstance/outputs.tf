output "sql_mi_id" {
  description = "The ID of the created Azure SQL Managed Instance"
  value       = azurerm_sql_managed_instance.sqlmi.id
}

output "sql_mi_fqdn" {
  description = "The fully qualified domain name (FQDN) of the SQL Managed Instance"
  value       = azurerm_sql_managed_instance.sqlmi.fqdn
}

output "private_endpoint_ip" {
  description = "The private IP address assigned to the SQL MI Private Endpoint"
  value       = azurerm_private_endpoint.private_endpoint.private_service_connection.0.private_ip_address
}
