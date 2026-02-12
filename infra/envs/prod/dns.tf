# Azure DNS zone for brandonbuster.com (Namecheap domain; nameservers set at registrar).
# Uses existing RG, provider, and tagging. Local state per environment.

variable "www_cname_target" {
  type        = string
  default     = "example.azurefd.net"
  description = "Target for the www CNAME record (e.g. Front Door endpoint)."
}

resource "azurerm_dns_zone" "main" {
  name                = "brandonbuster.com"
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags
}

# TODO: Apex (@) record will later alias to Azure Front Door (Phase 2+).
# Leave unconfigured until Front Door is provisioned.

resource "azurerm_dns_cname_record" "www" {
  name                = "www"
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  record              = var.www_cname_target
}
