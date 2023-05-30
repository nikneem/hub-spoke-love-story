param location string = resourceGroup().location

param privateDnsZones array

var vpnGatewaySubnetName = 'VpnGateway'

var primaryInboundDnsResolverEndpointIpAddress = '10.0.1.4' // First available IP Address in DnsPrimaryInboundSubnet
var secondaryInboundDnsResolverEndpointIpAddress = '10.0.2.4' // First available IP Address in DnsSecondaryInboundSubnet
var primaryInboundDnsResolverSubnetName = 'DnsPrimaryInboundSubnet' // First available IP Address in DnsPrimaryInboundSubnet
var secondaryInboundDnsResolverSubnetName = 'DnsSecondaryInboundSubnet' // First available IP Address in DnsPrimaryInboundSubnet

resource hubVnet 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: 'hsls-hub-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/20' // 4000 addresses
      ]
    }
    subnets: [
      {
        name: vpnGatewaySubnetName
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
      {
        name: primaryInboundDnsResolverSubnetName
        properties: {
          addressPrefix: '10.0.1.0/24'
          delegations: [
            {
              name: 'delegation'
              properties: {
                serviceName: 'Microsoft.Network/dnsResolvers'
              }
            }
          ]
          serviceEndpoints: []
        }
      }
      {
        name: secondaryInboundDnsResolverSubnetName
        properties: {
          addressPrefix: '10.0.2.0/24'
          delegations: [
            {
              name: 'delegation'
              properties: {
                serviceName: 'Microsoft.Network/dnsResolvers'
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

module dnsZoneModule 'dns-zones.bicep' = [for dnsZone in privateDnsZones: {
  name: 'PrivateDnsZone-${dnsZone}'
  params: {
    dnsZoneName: dnsZone
    virtualNetworkName: hubVnet.name
  }
}]

output vnetName string = hubVnet.name
output vpnGatewaySubnetName string = vpnGatewaySubnetName
output primaryInboundDnsResolverSubnetName string = primaryInboundDnsResolverSubnetName
output secondaryInboundDnsResolverSubnetName string = secondaryInboundDnsResolverSubnetName
output primaryInboundDnsResolverEndpointIpAddress string = primaryInboundDnsResolverEndpointIpAddress
output secondaryInboundDnsResolverEndpointIpAddress string = secondaryInboundDnsResolverEndpointIpAddress
