# Phase 2 – Azure Front Door (CDN) + WAF + custom domain. See docs/phase-2.md.

locals {
  fd_profile   = "${local.base}-fd"
  fd_endpoint  = "main"
  fd_origin_group = "api"
  fd_origin   = "api"
  api_hostname = "${azurerm_container_app.api.name}.${azurerm_container_app_environment.main.default_domain}"
}

resource "azurerm_cdn_frontdoor_profile" "main" {
  name                = local.fd_profile
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "Premium_AzureFrontDoor"  # Required for WAF and custom domain
  tags                = local.tags
}

resource "azurerm_cdn_frontdoor_endpoint" "main" {
  name                     = local.fd_endpoint
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  tags                     = local.tags
}

resource "azurerm_cdn_frontdoor_origin_group" "api" {
  name                     = local.fd_origin_group
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  session_affinity_enabled  = false

  health_probe {
    interval_in_seconds = 30
    path                = "/"
    protocol            = "Https"
    request_type        = "HEAD"
  }

  load_balancing {
    additional_latency_in_milliseconds = 0
    sample_size                        = 4
    successful_samples_required        = 2
  }
}

resource "azurerm_cdn_frontdoor_origin" "api" {
  name                           = local.fd_origin
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.api.id
  host_name                      = local.api_hostname
  origin_host_header             = local.api_hostname
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
  enabled                        = true

  # Container Apps use HTTPS on 443
  http_port  = 80
  https_port = 443
}

resource "azurerm_cdn_frontdoor_route" "api" {
  name                          = "api"
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.main.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.api.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.api.id]
  supported_protocols           = ["Https"]
  patterns_to_match             = ["/*"]
  forwarding_protocol           = "HttpsOnly"
  cdn_frontdoor_rule_set_ids    = []
}

# WAF policy
resource "azurerm_cdn_frontdoor_firewall_policy" "main" {
  name                              = "${local.base}-fd-waf"
  resource_group_name               = azurerm_resource_group.main.name
  sku_name                          = azurerm_cdn_frontdoor_profile.main.sku_name
  enabled                           = true
  mode                              = "Prevention"
  redirect_url                      = "https://www.brandonbuster.com"
  custom_block_response_status_code = 403
  custom_block_response_body        = base64encode("Access denied by WAF.")

  managed_rule {
    type    = "Microsoft_DefaultRuleSet"
    version = "2.1"
    action  = "Block"
  }

  managed_rule {
    type    = "Microsoft_BotManagerRuleSet"
    version = "1.0"
    action  = "Block"
  }
}

# Attach WAF to profile (security policy) – applies to default endpoint domain
resource "azurerm_cdn_frontdoor_security_policy" "main" {
  name                     = "waf"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.main.id
  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.main.id
      association {
        patterns_to_match = ["/*"]
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_endpoint.main.id
        }
      }
    }
  }
}
