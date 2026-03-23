terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
  }
}

/*resource "azurerm_public_ip" "publicip" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
}*/

resource "azurerm_network_interface" "nic" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = var.name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${var.name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "${var.name}-nsg"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = var.port
    source_address_prefixes    = var.subnet_cidr
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "default-deny"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_virtual_machine" "vm" {
  name                  = var.name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = var.vm_size
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true


  storage_image_reference {
    id                = var.storage_image_reference
  }
  storage_os_disk {
    name              = var.name
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = var.name
    admin_username = data.vault_generic_secret.roboshop-infra.data["username"]
    admin_password = data.vault_generic_secret.roboshop-infra.data["password"]
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

/*resource "null_resource" "ansible" {
  depends_on = [
    azurerm_virtual_machine.vm
  ]
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = data.vault_generic_secret.roboshop-infra.data["username"]
      password    = data.vault_generic_secret.roboshop-infra.data["password"]
      host        = azurerm_network_interface.nic.private_ip_address
    }

    inline = [
      "sudo dnf install python3.12 python3.12-pip -y",
      "sudo pip3.12 install ansible",
      "sudo pip3.12 install hvac",
      "ansible-pull -i localhost, -U https://github.com/ng1218/rb-ansible.git -e app_name=${local.app_name} -e env=dev -e token=${var.token} roboshop.yml"
    ]
  }
}*/

resource "azurerm_dns_a_record" "dns_record" {
  name                = "${ var.name }-dev"
  zone_name           = var.zone_name
  resource_group_name = var.dns_resource_group_name
  ttl                 = 3
  records             = [azurerm_network_interface.nic.private_ip_address]
}