output "webapp_url" {
  value = azurerm_linux_web_app.taskboardwebapp.default_hostname
}

output "webapp_ips" {
  value = azurerm_linux_web_app.taskboardwebapp.outbound_ip_addresses
}