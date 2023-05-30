param location string = resourceGroup().location

param vnetResourceGroup string
param vnetName string
param subnetName string


resource VNet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetResourceGroup)
  resource Subnet 'subnets' existing = {
    name: subnetName
  }
}

resource vpnGatewayPublicIp 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: 'hsls-hub-vpn-pip'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
    '2'
    '3'
  ]
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

resource vpnGateway 'Microsoft.Network/virtualNetworkGateways@2022-07-01' = {
  name: 'hsls-hub-vpn'
  location: location
  properties: {
    enablePrivateIpAddress: false
    enableBgpRouteTranslationForNat: false
    sku: {
      name: 'VpnGw2AZ'
      tier: 'VpnGw2AZ'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    activeActive: false
    ipConfigurations: [
      {
        name: 'default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: vpnGatewayPublicIp.id
          }
          subnet: {
            id: VNet::Subnet.id
          }
        }
      }
    ]
    bgpSettings: {
      asn: 0
      peerWeight: 0
    }
    vpnClientConfiguration: {
      aadAudience: '41b23e61-6c1e-4545-b367-cd054e0ed4b4'
      aadTenant: '${environment().authentication.loginEndpoint}${subscription().tenantId}'
      aadIssuer: 'https://sts.windows.net/${subscription().tenantId}/'
      vpnAuthenticationTypes: [
        'AAD'
      ]
      vpnClientAddressPool: {
        addressPrefixes: [
          '10.1.0.0/20'
        ]
      }
      vpnClientProtocols: [
        'OpenVPN'
      ]
    }
  }
}
