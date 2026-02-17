output "resource_group_name" {
  value       = azurerm_resource_group.main.name
  description = "Resource group name."
}

output "acr_login_server" {
  value       = azurerm_container_registry.main.login_server
  description = "ACR login server for docker push and image reference."
}

output "acr_name" {
  value       = azurerm_container_registry.main.name
  description = "ACR name (for az acr login)."
}

output "key_vault_name" {
  value       = azurerm_key_vault.main.name
  description = "Key Vault name for secrets."
}

output "container_app_api_fqdn" {
  value       = "http://${azurerm_container_app.api.name}.${azurerm_container_app_environment.main.default_domain}/"
  description = "API Container App URL (stable)."
}

output "application_insights_instrumentation_key" {
  value       = azurerm_application_insights.main.instrumentation_key
  sensitive   = true
  description = "App Insights instrumentation key."
}

output "dns_nameservers" {
  value       = azurerm_dns_zone.main.name_servers
  description = "Nameservers to set at Namecheap (Domain → Manage → Nameservers → Custom DNS)."
}

# Phase 2 – Front Door
output "frontdoor_endpoint_hostname" {
  value       = azurerm_cdn_frontdoor_endpoint.main.host_name
  description = "Front Door default endpoint hostname (use for www CNAME)."
}
