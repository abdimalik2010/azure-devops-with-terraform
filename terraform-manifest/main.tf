terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.18"

    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.27"
    }
    name = {
      source  = "hashicorp/random"
      version = ">= 3.3"
    }

  }

}


provider "azurerm" {

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  
 

}
provider "random" {

}
resource "random_pet" "aksrandom" {

  keepers = {
    rs = var.petcount
  }
}

resource "azurerm_resource_group" "RG1" {
  name     = "${var.resource_group_name}-${var.env}"
  location = var.location
  tags = {
    "country" = "germany"
  }
}
# Create Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "insights" {
  name                = "${var.env}-logs-${random_pet.aksrandom.id}"
  location            = azurerm_resource_group.RG1.location
  resource_group_name = azurerm_resource_group.RG1.name
  retention_in_days   = 30
  sku                 = "PerGB2018"
}
resource "azuread_group" "aks_administrators" {
  display_name     = "$${var.env}-administrators"
  description      = "Azure AKS Kubernetes administrators for the ${azurerm_resource_group.RG1.name}-${var.env} cluster."
  security_enabled = true

}

resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                = "aks-${var.env}"
  location            = azurerm_resource_group.RG1.location
  resource_group_name = azurerm_resource_group.RG1.name
  tags                = azurerm_resource_group.RG1.tags
  dns_prefix          = azurerm_resource_group.RG1.name
  node_resource_group = "${azurerm_resource_group.RG1.name}-nrg"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version


  default_node_pool {
    name                 = "systempool"
    vm_size              = "Standard_D2_v2"
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    enable_auto_scaling  = true
    node_count           = 1
    max_count            = 2
    min_count            = 1
    os_disk_size_gb      = 30
    type                 = "VirtualMachineScaleSets"

    node_labels = {
      "nodepool-type" = "system"
      "environment"   = var.env
      "nodepoolos"    = "linux"
      "app"           = "system-apps"
    }
  }
  linux_profile {
    admin_username = "kroo"
    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }
  windows_profile {
    admin_username = var.windows_admin_username
    admin_password = var.windows_admin_password
  }
  network_profile {
    load_balancer_sku = "standard"
    network_plugin    = "azure"
  }
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.insights.id
  }

  role_based_access_control_enabled = true
  azure_active_directory_role_based_access_control {
    azure_rbac_enabled     = true
    managed                = true
    admin_group_object_ids = [azuread_group.aks_administrators.id]
  }

  identity {
    type = "SystemAssigned"
  }

}