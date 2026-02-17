# Azure DNS zone for brandonbuster.com (Namecheap domain; nameservers set at registrar).
# Phase 2: www and (optional) apex point to Front Door. See docs/phase-2.md.

resource "azurerm_dns_zone" "main" {
  name                = "brandonbuster.com"
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags
}

# www → Front Door endpoint (Phase 2)
resource "azurerm_dns_cname_record" "www" {
  name                = "www"
  zone_name           = azurerm_dns_zone.main.name
  resource_group_name = azurerm_resource_group.main.name
  ttl                 = 300
  record              = azurerm_cdn_frontdoor_endpoint.main.host_name
}

# Apex: use Azure DNS alias record to Front Door when supported, or add CNAME flattening.
# Optional – uncomment and set target when apex routing is required.
# resource "azurerm_dns_a_record" "apex" { ... }
