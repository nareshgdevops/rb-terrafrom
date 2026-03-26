resource "azurerm_key_vault" "key-vault" {
  name                        = var.key-vault-name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  enabled_for_disk_encryption = true
  purge_protection_enabled    = true
}

resource "azurerm_key_vault_key" "vault-key" {
  name         = var.vault-key
  key_vault_id = azurerm_key_vault.key-vault.id
  key_type     = "RSA"
  key_size     = 2048

  /*depends_on = [
    azurerm_key_vault_access_policy.disk-acc-policy
  ]*/

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
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

/*resource "azurerm_key_vault_access_policy" "disk-acc-policy" {
  key_vault_id = azurerm_key_vault.key-vault.id

  tenant_id = azurerm_disk_encryption_set.des.identity[0].tenant_id
  object_id = azurerm_disk_encryption_set.des.identity[0].principal_id

  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "Purge",
    "Recover",
    "Update",
    "List",
    "Decrypt",
    "Sign",
  ]
}

resource "azurerm_key_vault_access_policy" "user-acc-policy" {
  key_vault_id = azurerm_key_vault.key-vault.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = data.azurerm_client_config.current.object_id

  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "Purge",
    "Recover",
    "Update",
    "List",
    "Decrypt",
    "Sign",
    "GetRotationPolicy",
  ]
}

resource "azurerm_role_assignment" "example-disk" {
  scope                = azurerm_key_vault.key-vault.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_disk_encryption_set.des.identity[0].principal_id
}*/