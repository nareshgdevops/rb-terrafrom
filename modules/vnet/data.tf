data "azurerm_virtual_network" "tools-vnet" {
  name                = "vnet-ukwest"
  resource_group_name = "ngresources"
}