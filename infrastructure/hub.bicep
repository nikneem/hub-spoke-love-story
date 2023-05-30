targetScope = 'subscription'

param location string = deployment().location
param privateDnsZones array

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
    privateDnsZones: privateDnsZones
  }
}

module dnsResolver 'Network/dns-resolver.bicep' = {
  name: 'dnsResolverModule'
  scope: targetResourceGroup
  params: {
    defaultResourceName: systemName
    location: location
    vnetResourceGroup: targetResourceGroup.name
    vnetName: vnetModule.outputs.vnetName
    primarySubnetName: vnetModule.outputs.primaryInboundDnsResolverSubnetName
    secondarySubnetName: vnetModule.outputs.secondaryInboundDnsResolverSubnetName
    primaryStaticIpAddress: vnetModule.outputs.primaryInboundDnsResolverEndpointIpAddress
    secondaryStaticIpAddress: vnetModule.outputs.secondaryInboundDnsResolverEndpointIpAddress
  }
}

module vpnGateway 'Network/gw.bicep' = {
  name: 'vpnGatewayModule'
  scope: targetResourceGroup
  params: {
    vnetResourceGroup: targetResourceGroup.name
    location: location
    vnetName: vnetModule.outputs.vnetName
    subnetName: vnetModule.outputs.vpnGatewaySubnetName

  }
}
