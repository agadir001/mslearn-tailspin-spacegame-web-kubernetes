locals {
  # Naming locals/constants
  name_prefix = lower(var.acr_name_prefix)
  name_suffix = lower(var.acr_name_suffix)

  acr_name = coalesce(var.acr_custom_name, "acrtestsshtech")
}

locals {
  acr_default_tags = var.acr_default_tags_enabled ? {
    stack = var.acr_stack
  } : {}
}

resource "azurerm_container_registry" "registry" {
  name = local.acr_name

  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.acr_sku
  admin_enabled       = var.acr_admin_enabled

  public_network_access_enabled = var.acr_public_network_access_enabled
  network_rule_bypass_option    = var.acr_azure_services_bypass_allowed ? "AzureServices" : "None"

  data_endpoint_enabled = var.acr_data_endpoint_enabled

  dynamic "retention_policy" {
    for_each = var.acr_images_retention_enabled && var.acr_sku == "Premium" ? ["enabled"] : []

    content {
      enabled = var.acr_images_retention_enabled
      days    = var.acr_images_retention_days
    }
  }

  dynamic "trust_policy" {
    for_each = var.acr_trust_policy_enabled && var.acr_sku == "Premium" ? ["enabled"] : []

    content {
      enabled = var.acr_trust_policy_enabled
    }
  }

  dynamic "georeplications" {
    for_each = var.acr_georeplication_locations != null && var.acr_sku == "Premium" ? var.acr_georeplication_locations : []

    content {
      location                  = try(georeplications.value.location, georeplications.value)
      zone_redundancy_enabled   = try(georeplications.value.zone_redundancy_enabled, null)
      regional_endpoint_enabled = try(georeplications.value.regional_endpoint_enabled, null)
      tags                      = try(georeplications.value.tags, null)
    }
  }

  dynamic "network_rule_set" {
    for_each = length(concat(var.acr_allowed_cidrs, var.acr_allowed_subnets)) > 0 ? ["enabled"] : []

    content {
      default_action = "Deny"

      dynamic "ip_rule" {
        for_each = var.acr_allowed_cidrs
        content {
          action   = "Allow"
          ip_range = ip_rule.value
        }
      }

      dynamic "virtual_network" {
        for_each = var.acr_allowed_subnets
        content {
          action    = "Allow"
          subnet_id = virtual_network.value
        }
      }
    }
  }

  tags = merge(local.acr_default_tags, var.acr_extra_tags)

  lifecycle {
    precondition {
      condition     = !var.acr_data_endpoint_enabled || var.acr_sku == "Premium"
      error_message = "Premium SKU is mandatory to enable the data endpoints."
    }
  }
}
