targetScope = 'subscription'

param location string = deployment().location
param privateDnsZones array = []
var systemName = 'hubspoke-love-story-spoke'
var hubResourceGroupName = 'hubspoke-love-story-hub'
var hubVnetName = 'hsls-hub-vnet'

resource targetResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: systemName
  location: location
}

module spokeVnet 'Network/spoke-network.bicep' = {
  name: 'spokeVnetModule'
  scope: targetResourceGroup
  params: {
    location: location
    privateDnsZones: privateDnsZones
    hubVnetResourceGroupName: hubResourceGroupName
    hubVnetName: hubVnetName
  }
}

module storageAccount 'Storage/storageAccounts.bicep' = {
  scope: targetResourceGroup
  name: 'storageAccountModule'
  params: {
    defaultResourceName: 'hsls-spoke-vnet'
    location: location
  }
}

module webApp 'Web/webapp.bicep' = {
  scope: targetResourceGroup
  name: 'webAppModule'
  params: {
    defaultResourceName: 'hsls-spoke-vnet'
    location: location
    storageAccountName: storageAccount.outputs.storageAccountName
  }
}

module roleAssignments 'Authorization/web-app-role-assignments.bicep' = {
  scope: targetResourceGroup
  name: 'roleAssignmentsModule'
  params: {
    webAppservicePrincipalId: webApp.outputs.webAppResourceIdentity
  }
}
