resource "azurerm_key_vault" "key-vault" {
  name                        = var.key-vault-name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  enabled_for_disk_encryption = true
  purge_protection_enabled    = true

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Decrypt", "Encrypt",
      "UnwrapKey", "WrapKey", "Verify", "Sign", "Purge", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"
    ]
  }
}

resource "time_sleep" "wait_for_kv_permissions" {
  depends_on = [azurerm_key_vault.key-vault]
  create_duration = "30s"
}

resource "azurerm_key_vault_key" "vault-key" {
  name         = var.vault-key
  key_vault_id = azurerm_key_vault.key-vault.id
  key_type     = "RSA"
  key_size     = 2048

  depends_on = [
    time_sleep.wait_for_kv_permissions
  ]

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  lifecycle {
    prevent_destroy = true
  }

}

resource "azurerm_disk_encryption_set" "des" {
  name                  = var.name
  location              = var.location
  resource_group_name   = var.resource_group_name
  key_vault_key_id      = azurerm_key_vault_key.vault-key.id

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_key_vault_access_policy" "for-disk" {
  key_vault_id = azurerm_key_vault.key-vault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_disk_encryption_set.des.identity.0.principal_id

  key_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Decrypt", "Encrypt", "UnwrapKey", "WrapKey", "Verify", "Sign", "Purge", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
}