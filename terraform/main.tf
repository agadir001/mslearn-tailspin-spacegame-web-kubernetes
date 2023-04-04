# Generate random resource group name
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
}

resource "random_id" "log_analytics_workspace_name_suffix" {
  byte_length = 8
}

resource "azurerm_log_analytics_workspace" "test" {
  location            = var.log_analytics_workspace_location
  # The WorkSpace name has to be unique across the whole of azure;
  # not just the current subscription/tenant.
  name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "test" {
  location              = azurerm_log_analytics_workspace.test.location
  resource_group_name   = azurerm_resource_group.rg.name
  solution_name         = "ContainerInsights"
  workspace_name        = azurerm_log_analytics_workspace.test.name
  workspace_resource_id = azurerm_log_analytics_workspace.test.id

  plan {
    product   = "OMSGallery/ContainerInsights"
    publisher = "Microsoft"
  }
}

resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.rg.location
  name                = var.cluster_name
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix
  tags                = {
    Environment = "Development"
  }

  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = var.agent_count
  }
  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = file(data.azurerm_key_vault_secret.ssh_public_key.value)
    }
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
  service_principal {
    client_id     = data.azurerm_key_vault_secret.client_id.value
    client_secret = data.azurerm_key_vault_secret.client_secret.value
  }
}

data "azurerm_key_vault_secret" "ssh_public_key" {
  name         = "sshpublickey"
  key_vault_id = "/subscriptions/65ec60b1-3471-45ff-b9ea-cf8347119ad5/resourceGroups/core-rg/providers/Microsoft.KeyVault/vaults/demoacraz400"
}

data "azurerm_key_vault_secret" "client_id" {
  name         = "spappid"
  key_vault_id = "/subscriptions/65ec60b1-3471-45ff-b9ea-cf8347119ad5/resourceGroups/core-rg/providers/Microsoft.KeyVault/vaults/demoacraz400"
}

data "azurerm_key_vault_secret" "client_secret" {
  name         = "sppassword"
  key_vault_id = "/subscriptions/65ec60b1-3471-45ff-b9ea-cf8347119ad5/resourceGroups/core-rg/providers/Microsoft.KeyVault/vaults/demoacraz400"
}
