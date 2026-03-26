env                       = "dev"
zone_name                 = "nareshdevops1218.online"
subnet_id                 = "/subscriptions/ddffee8a-e239-4aa1-b7e0-b88ff5a2f9aa/resourceGroups/ngresources/providers/Microsoft.Network/virtualNetworks/vnet-ukwest/subnets/snet-ukwest-1"

storage_image_reference   = "/subscriptions/ddffee8a-e239-4aa1-b7e0-b88ff5a2f9aa/resourceGroups/ngresources/providers/Microsoft.Compute/images/local-devops-practice"

network_security_group_id = "/subscriptions/ddffee8a-e239-4aa1-b7e0-b88ff5a2f9aa/resourceGroups/ngresources/providers/Microsoft.Network/networkSecurityGroups/test-allow-all"

subscription_id           = "ddffee8a-e239-4aa1-b7e0-b88ff5a2f9aa"
dns_resource_group_name   = "ngresources"
tools_vnet_resource_id    = "/subscriptions/ddffee8a-e239-4aa1-b7e0-b88ff5a2f9aa/resourceGroups/ngresources/providers/Microsoft.Network/virtualNetworks/vnet-ukwest"
applications = {
    frontend  = {
      rgname = "ukwest"
    }
    catalogue = {
      rgname = "ukwest"
    }
    user      = {
      rgname = "ukwest"
    }
    cart      = {
      rgname = "ukwest"
    }
    shipping  = {
      rgname = "ukwest"
    }
    payment   = {
      rgname = "ukwest"
    }
  }

databases = {
    mongodb = {
      rgname  = "ukwest"
      vnet    = "main"
      subnet  = "main"
      vm_size = "Standard_D2s_v3"
      port    = ["22", "27017"]
      des     = "main-des"
    }
    mysql = {
      rgname = "ukwest"
      vnet    = "main"
      subnet  = "main"
      vm_size = "Standard_D2s_v3"
      port    = ["22", "3306"]
    }
    redis = {
      rgname = "ukwest"
      vnet    = "main"
      subnet  = "main"
      vm_size = "Standard_D2s_v3"
      port    = ["22", "6379"]
    }
    rabbitmq = {
      rgname = "ukwest"
      vnet    = "main"
      subnet  = "main"
      vm_size = "Standard_D2s_v3"
      port    = ["22", "5672"]
    }
  }

rg_name = {
    ukwest = {
      location = "UK West"
    }
}

vnet = {
  main = {
    rgname = "ukwest"
    address_space = ["10.51.0.0/16"]
    subnets = {
      main = {
        address_prefix = ["10.51.0.0/24"]
      }

    }
  }
}

aks = {
  aks-main-dev = {
    rgname = "ukwest"
    vnet    = "main"
    subnet  = "main"
    default_node_pool = {
      vm_size = "Standard_D2ls_v5"
      node_count = 1
    }
    app_node_pool = {
      roboshop = {
        vm_size = "Standard_D2ls_v5"
        min_count = 2
        max_count = 10
        auto_scaling_enabled = true
        node_labels = {
          "project/name" = "roboshop"
        }
      }
    }
  }
}

#bastion_nodes = ["172.16.0.100", "172.16.0.10"]

des = {
  main-des = {
    rgname = "ukwest"
    key-vault-name = "nareshdevops1218"
    vault-key = "vk123"
  }
}