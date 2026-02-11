# Remote state: create Azure Storage Account and container first (bootstrap), then uncomment and set:
# terraform init -backend-config=backend.dev.tfvars
#
# backend "azurerm" {
#   resource_group_name  = "bb-tfstate-rg"
#   storage_account_name = "bbtfstate"
#   container_name       = "tfstate"
#   key                  = "dev.terraform.tfstate"
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
