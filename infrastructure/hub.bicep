targetScope = 'subscription'

param location string = deployment().location

var systemName = 'hubspoke-love-story-hub'

resource targetResourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: systemName
  location: location
}

module vnetModule 'Network/hub-vnet.bicep' = {
  name: 'vnetModule'
  scope: targetResourceGroup
  params: {
    location: location
  }
}
