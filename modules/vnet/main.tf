resource "azurerm_virtual_network" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
}

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnets
  name                 = "${each.key}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = each.value["address_prefix"]
}

resource "azurerm_virtual_network_peering" "here-to-tools" {
  name                      = "${var.name}-conn-to-tools"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.main.name
  remote_virtual_network_id = var.tools_vnet_resource_id
}

resource "azurerm_virtual_network_peering" "tools-to-here" {
  name                      = "conn-to-${var.name}"
  resource_group_name       = data.azurerm_virtual_network.tools-vnet.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.tools-vnet.name
  remote_virtual_network_id = azurerm_virtual_network.main.id
}