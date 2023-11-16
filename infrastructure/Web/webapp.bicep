param location string
param defaultResourceName string
param storageAccountName string

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: '${defaultResourceName}-plan'
  location: location
  kind: 'linux'
  sku: {
    name: 'S1'
    tier: 'Standard'
    capacity: 1
  }
  properties: {
    reserved: true
  }
}

var config = [
  {
    name: 'AzureStorageAccountName'
    value: storageAccountName
  }
]

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: '${defaultResourceName}-webapp'
  location: location
  kind: 'linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    enabled: true
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      alwaysOn: true
      ftpsState: 'Disabled'
      linuxFxVersion: 'DOTNETCORE|8.0'
      webSocketsEnabled: false
      appSettings: config

    }
  }
}

output webAppResourceName string = webApp.name
output webAppResourceIdentity string = webApp.identity.principalId
