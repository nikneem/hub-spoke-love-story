param location string = resourceGroup().location

param privateDnsZones array

param hubVnetResourceGroupName string
param hubVnetName string

var primaryInboundDnsResolverEndpointIpAddress = '10.0.1.4' // First available IP Address in DnsPrimaryInboundSubnet
var secondaryInboundDnsResolverEndpointIpAddress = '10.0.2.4' // First available IP Address in DnsSecondaryInboundSubnet

resource spokeVnet 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: 'hsls-spoke-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/23' // 4000 addresses
      ]
    }
    subnets: [
      {
        name: 'StorageDataSubnet'
        properties: {
          addressPrefix: '10.1.0.0/24'
        }
      }
      {
        name: 'WebAppSubnet'
        properties: {
          addressPrefix: '10.1.1.0/24'
          delegations: [
            {
              name: 'delegation'
              properties: {
                serviceName: 'Microsoft.Web/serverfarms'
              }
            }
          ]
          serviceEndpoints: []
        }
      }
    ]
    dhcpOptions: {
      dnsServers: [
        primaryInboundDnsResolverEndpointIpAddress
        secondaryInboundDnsResolverEndpointIpAddress
      ]
    }
  }
}

module spokeToHubPeering 'vnetPeering.bicep' = {
  name: 'spokeToHubPeeringModule'
  scope: resourceGroup()
  params: {
    networkPeeringName: 'spoke-to-hub'
    networkName: spokeVnet.name
    removeNetworkResourceGroup: hubVnetResourceGroupName
    remoteNetworkName: hubVnetName
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: true
    doNotVerifyRemoteGateways: false
  }
}

module hubToSpokePeering 'vnetPeering.bicep' = {
  name: 'hubToSpokePeeringModule'
  scope: resourceGroup(hubVnetResourceGroupName)
  params: {
    networkPeeringName: 'hub-to-spoke'
    networkName: hubVnetName
    removeNetworkResourceGroup: resourceGroup().name
    remoteNetworkName: spokeVnet.name
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    doNotVerifyRemoteGateways: false
  }
}

module dnsZoneModule 'dns-zone-link.bicep' = [for dnsZone in privateDnsZones: {
  name: 'PrivateDnsZone-${dnsZone}'
  scope: resourceGroup(hubVnetResourceGroupName)
  params: {
    dnsZoneName: dnsZone
    virtualNetworkName: spokeVnet.name
    virtualNetworkResourceGroupName: resourceGroup().name
  }
}]

output vnetName string = spokeVnet.name
output primaryInboundDnsResolverEndpointIpAddress string = primaryInboundDnsResolverEndpointIpAddress
output secondaryInboundDnsResolverEndpointIpAddress string = secondaryInboundDnsResolverEndpointIpAddress
