resource "azurerm_private_dns_zone" "dns_mysql" {
  name                = "dns.mysql.database.azure.com"
  resource_group_name = var.rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_vnet_link" {
  name                  = "mySQLVnetZone.com"
  private_dns_zone_name = azurerm_private_dns_zone.dns_mysql.name
  virtual_network_id    = var.vnet_id
  resource_group_name   = var.rg_name
}

resource "azurerm_mysql_flexible_server" "mysql_fs" {
  name                   = var.name
  resource_group_name    = var.rg_name
  location               = var.location
  administrator_login    = "psqladmin"
  administrator_password = "H@Sh1CoR3!"
  backup_retention_days  = 7
  delegated_subnet_id    = var.subnet_id
  private_dns_zone_id    = azurerm_private_dns_zone.dns_mysql.id
  # sku_name               = "GP_Standard_D2ds_v4"

  depends_on = [azurerm_private_dns_zone_virtual_network_link.dns_vnet_link]
}