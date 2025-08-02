# terraform {
#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       version = "4.38.1"
#     }
#   }
# }

# provider "azurerm" {
#   subscription_id = "db3c4452-c8ce-4bfd-b603-52f86c2380a8"
#   features {

#   }
# }

resource "azurerm_resource_group" "mystoragerg" {
  name     = "MyStorageRG2"
  location = "North Europe"
}

resource "azurerm_storage_account" "mystorageaccount" {
  name                     = "taskboardsa2025"
  resource_group_name      = azurerm_resource_group.mystoragerg.name
  location                 = azurerm_resource_group.mystoragerg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "mystoragecontainer" {
  name                  = "taskboardsc2025"
  storage_account_id    = azurerm_storage_account.mystorageaccount.id
  container_access_type = "private"
}