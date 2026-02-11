# Remote state: use same storage as dev with different key. Uncomment after bootstrap.
#
# backend "azurerm" {
#   resource_group_name  = "bb-tfstate-rg"
#   storage_account_name = "bbtfstate"
#   container_name       = "tfstate"
#   key                  = "prod.terraform.tfstate"
# }

terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.45"
    }
  }
}
