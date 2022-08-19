# Create Outputs
# 1. Resource Group Location
# 2. Resource Group Id
# 3. Resource Group Name

# Resource Group Outputs
output "location" {
  value = azurerm_resource_group.RG1.location
}

output "resource_group_id" {
  value = azurerm_resource_group.RG1.id
}

output "resource_group_name" {
  value = azurerm_resource_group.RG1.name
}

# Azure AKS Versions Datasource
output "versions" {
  value = data.azurerm_kubernetes_service_versions.current.versions
}

output "latest_version" {
  value = data.azurerm_kubernetes_service_versions.current.latest_version
}

# Azure AD Group Object Id
output "azure_ad_group_id" {
  value = azuread_group.aks_administrators.id
}
output "azure_ad_group_objectid" {
  value = azuread_group.aks_administrators.object_id
}

# Azure aks cluster outputs
output "azurerm_aks_cluster" {
  value = azurerm_kubernetes_cluster.aks-cluster.id
}

output "petname" {
  value = random_pet.aksrandom.*.id
}
