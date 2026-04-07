output "subnet" {
  value = azurerm_subnet.subnet
}

output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.main.id
}