resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.name
  location            = var.location
  resource_group_name = var.rg_name
  dns_prefix          = "roboshopdns"

  default_node_pool {
    name       = "default"
    node_count = var.default_node_pool["node_count"]
    vm_size    = var.default_node_pool["vm_size"]
    vnet_subnet_id = var.subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
  }

  aci_connector_linux {
    subnet_name = var.subnet_id
  }

  lifecycle {
    ignore_changes = [
      default_node_pool
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "main" {
  for_each              = var.app_node_pool
  name                  = each.key
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vnet_subnet_id        = var.subnet_id
  vm_size               = each.value["vm_size"]
  node_count            = each.value["min_count"]
  auto_scaling_enabled  = each.value["auto_scaling_enabled"]
  min_count             = each.value["min_count"]
  max_count             = each.value["max_count"]
  node_labels           = each.value["node_labels"]
}
