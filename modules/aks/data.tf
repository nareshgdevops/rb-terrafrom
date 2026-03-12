data "azurerm_container_registry" "acr" {
  name                = "nareshgdevops"
  resource_group_name = "ngresources"
}

output "acr1" {
  value = data.azurerm_container_registry.acr
}