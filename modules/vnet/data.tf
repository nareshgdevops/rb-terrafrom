data "azurerm_virtual_network" "tools-vnet" {
  name                = "main"
  resource_group_name = "ngresources"
}