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
}

var config = [
  {
    name: 'AzureStorageAccount'
    value: storageAccountName
  }
]

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: '${defaultResourceName}-app'
  location: location
  kind: 'linux'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    enabled: true
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
  resource appConfig 'config@2022-03-01' = {
    name: 'web'
    properties: {
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
      http20Enabled: true
      netFrameworkVersion: 'v7.0'
      linuxFxVersion: 'dotnet-isolated|7.0'
      appSettings: config
    }
  }
}

output webAppResourceName string = webApp.name
output webAppResourceIdentity string = webApp.identity.principalId
