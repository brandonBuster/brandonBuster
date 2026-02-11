# Phase 1 – Cloud foundation: RG, ACR, Key Vault, Observability, Container Apps.
# requirements §4, §5. See docs/phase-1.md.

locals {
  env   = var.environment
  base  = "${var.prefix}-${local.env}"
  rg    = "${local.base}-rg"
  acr   = replace("${local.base}acr", "-", "") # ACR: alphanumeric only, globally unique
  kv    = replace("${local.base}-kv", "-", "")  # Key Vault: alphanumeric and hyphen, globally unique
  log   = "${local.base}-log"
  appi  = "${local.base}-appi"
  cae   = "${local.base}-cae"
  api   = "${local.base}-api"
  tags  = { environment = local.env, project = var.prefix }
}

# Resource group
resource "azurerm_resource_group" "main" {
  name     = local.rg
  location = var.location
  tags     = local.tags
}

# Azure Container Registry
resource "azurerm_container_registry" "main" {
  name                = local.acr
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = var.acr_sku
  admin_enabled       = false
  tags                = local.tags
}

# User-assigned managed identity for Container App (ACR pull + Key Vault access)
resource "azurerm_user_assigned_identity" "api" {
  name                = "${local.api}-id"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  tags                = local.tags
}

# ACR AcrPull for the API identity
resource "azurerm_role_assignment" "api_acr_pull" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.api.principal_id
}

# Key Vault
resource "azurerm_key_vault" "main" {
  name                        = local.kv
  resource_group_name          = azurerm_resource_group.main.name
  location                    = azurerm_resource_group.main.location
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days   = 7
  purge_protection_enabled    = false
  tags                        = local.tags
}

# Key Vault access for the API managed identity (e.g. for SendGrid key later)
resource "azurerm_key_vault_access_policy" "api" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.api.principal_id
  secret_permissions = [
    "Get", "List"
  ]
}

# Current client (e.g. run Terraform as) – list/get secrets for initial setup
resource "azurerm_key_vault_access_policy" "terraform" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id
  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover"
  ]
}

data "azurerm_client_config" "current" {}

# Log Analytics workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = local.log
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.tags
}

# Application Insights
resource "azurerm_application_insights" "main" {
  name                = local.appi
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  workspace_id       = azurerm_log_analytics_workspace.main.id
  application_type   = "other"
  tags                = local.tags
}

# Action group for alerts (email optional; can add later)
resource "azurerm_monitor_action_group" "main" {
  name                = "${local.base}-ag"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "bb${local.env}"
  tags                = local.tags
}

# Container Apps Environment
resource "azurerm_container_app_environment" "main" {
  name                       = local.cae
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  tags                       = local.tags
}

# Container App (API)
resource "azurerm_container_app" "api" {
  name                         = local.api
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.api.id]
  }

  registry {
    server   = azurerm_container_registry.main.login_server
    identity = azurerm_user_assigned_identity.api.id
  }

  template {
    min_replicas = 0
    max_replicas = 3
    container {
      name   = "api"
      image  = var.container_app_api_image
      cpu    = 0.25
      memory = "0.5Gi"
      liveness_probe {
        path             = "/"
        port             = var.container_app_api_port
        transport        = "HTTP"
        initial_delay    = 10
        interval_seconds = 20
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = var.container_app_api_port
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = local.tags
}

# Alert: Container App restarts (requirements §4, §5)
resource "azurerm_monitor_metric_alert" "api_restarts" {
  name                = "${local.api}-restarts"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = [azurerm_container_app.api.id]
  description         = "Alert when API container has high restart count."
  severity            = 2
  enabled             = true

  criteria {
    metric_namespace = "Microsoft.App/containerApps"
    metric_name      = "RestartCount"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 5
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = local.tags
}
