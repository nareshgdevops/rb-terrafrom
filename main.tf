module "resource_group" {
  for_each  = var.rg_name
  source    = "./modules/resource-group"
  location  = each.value["location"]
  rg_name   = "${each.key}-${var.env}"
}

module "vnet" {
  for_each                = var.vnet
  source                  = "./modules/vnet"
  name                    = "${each.key}-${var.env}"
  location                = module.resource_group[each.value["rgname"]].location
  resource_group_name     = module.resource_group[each.value["rgname"]].name
  address_space           = each.value["address_space"]
  subnets                 = each.value["subnets"]
  tools_vnet_resource_id  = var.tools_vnet_resource_id
  env                     = var.env
}

####OUTPUT OF RESOURCE GROUP AS BELOW########
/*output "rgtest" {
  value = module.resource_group
}*/

/*rgtest = {
  "ukwest" = {
    "id" = "/subscriptions/ddffee8a-e239-4aa1-b7e0-b88ff5a2f9aa/resourceGroups/ukwest-dev"
    "location" = "ukwest"
    "name" = "ukwest-dev"
  }
}*/
/*module "applications" {
  depends_on                = [module.databases]
  for_each                  = var.applications
  source                    = "./modules/vm"
  location                  = module.resource_group[each.value["rgname"]].location
  name                      = each.key
  resource_group_name       = module.resource_group[each.value["rgname"]].name
  network_security_group_id = var.network_security_group_id
  storage_image_reference   = var.storage_image_reference
  subnet_id                 = var.subnet_id
  zone_name                 = var.zone_name
  dns_resource_group_name   = var.dns_resource_group_name
  token                     = var.token
  type                      = "app"
}*/

module "des" {
  for_each                  = var.des
  name                      = each.key
  source                    = "./modules/des"
  location                  = module.resource_group[each.value["rgname"]].location
  resource_group_name       = module.resource_group[each.value["rgname"]].name
  key-vault-name            = each.value["key-vault-name"]
  vault-key                 = each.value["vault-key"]
}

output "current_config" {
  value = module.des
}

output "current_config1" {
  value = module.des
}
module "databases" {
  for_each                  = var.databases
  source                    = "./modules/vm"
  location                  = module.resource_group[each.value["rgname"]].location
  name                      = each.key
  resource_group_name       = module.resource_group[each.value["rgname"]].name
  network_security_group_id = var.network_security_group_id
  storage_image_reference   = var.storage_image_reference
  subnet_id                 = module.vnet[each.value["vnet"]].subnet[each.value["subnet"]].id
  subnet_cidr               = module.vnet[each.value["vnet"]].subnet[each.value["subnet"]].address_prefixes
  zone_name                 = var.zone_name
  dns_resource_group_name   = var.dns_resource_group_name
  token                     = var.token
  type                      = "db"
  vm_size                   = each.value["vm_size"]
  port                      = each.value["port"]
  disk_encryption_set_id    = module.des["main-des"].des_id
}

module "aks" {
  source         = "./modules/aks"
  for_each       = var.aks
  name           = each.key
  rg_name        = module.resource_group[each.value["rgname"]].name
  location       = module.resource_group[each.value["rgname"]].location
  env            = var.env
  token          = var.token
  subnet_id      = module.vnet[each.value["vnet"]].subnet[each.value["subnet"]].id
  app_node_pool  = each.value["app_node_pool"]
  default_node_pool = each.value["default_node_pool"]
}

# output "test" {
#   value = nonsensitive(module.aks)
# }