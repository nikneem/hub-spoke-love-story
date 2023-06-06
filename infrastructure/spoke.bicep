targetScope = 'subscription'

param location string = deployment().location

var systemName = 'hubspoke-love-story-spoke'

resource targetResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: systemName
  location: location
}

module storageAccount 'Storage/storageAccounts.bicep' = {
  scope: targetResourceGroup
  name: 'storageAccountModule'
  params: {
    defaultResourceName: systemName
    location: location
  }
}

module webApp 'Web/webapp.bicep' = {
  scope: targetResourceGroup
  name: 'webAppModule'
  params: {
    defaultResourceName: systemName
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
