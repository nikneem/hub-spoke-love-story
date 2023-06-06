param networkName string

param removeNetworkResourceGroup string
param remoteNetworkName string

param allowVirtualNetworkAccess bool = true
param allowForwardedTraffic bool = true
param allowGatewayTransit bool = false
param doNotVerifyRemoteGateways bool = false
param useRemoteGateways bool = false
param networkPeeringName string

resource localNetwork 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: networkName
}

resource peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-11-01' = {
  name: networkPeeringName
  parent: localNetwork
  properties: {
    allowVirtualNetworkAccess: allowVirtualNetworkAccess
    allowForwardedTraffic: allowForwardedTraffic
    allowGatewayTransit: allowGatewayTransit
    doNotVerifyRemoteGateways: doNotVerifyRemoteGateways
    useRemoteGateways: useRemoteGateways
    remoteVirtualNetwork: {
      id: resourceId(removeNetworkResourceGroup, 'Microsoft.Network/virtualNetworks', remoteNetworkName)
    }
  }
}
