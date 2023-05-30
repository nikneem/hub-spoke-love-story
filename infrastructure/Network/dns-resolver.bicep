param vnetResourceGroup string
param vnetName string
param primarySubnetName string
param secondarySubnetName string
param primaryStaticIpAddress string
param secondaryStaticIpAddress string
param defaultResourceName string
param location string

resource VNet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetResourceGroup)
  resource primarySubnet 'subnets' existing = {
    name: primarySubnetName
  }
  resource secondarySubnet 'subnets' existing = {
    name: secondarySubnetName
  }
}



resource dnsResolver 'Microsoft.Network/dnsResolvers@2022-07-01' = {
  name: '${defaultResourceName}-res'
  location: location
  properties: {
    virtualNetwork: {
      id: VNet.id
    }
  }
}

resource dnsPrimaryResolverInbound 'Microsoft.Network/dnsResolvers/inboundEndpoints@2022-07-01' = {
  name: '${defaultResourceName}-res-inb001'
  location: location
  parent: dnsResolver
  properties: {
    ipConfigurations: [
      {
        subnet: {
          id: VNet::primarySubnet.id
        }
        privateIpAllocationMethod: 'Dynamic'
      }
    ]
  }
}
resource dnsSecondaryResolverInbound 'Microsoft.Network/dnsResolvers/inboundEndpoints@2022-07-01' = {
  name: '${defaultResourceName}-res-inb002'
  location: location
  parent: dnsResolver
  properties: {
    ipConfigurations: [
      {
        subnet: {
          id: VNet::secondarySubnet.id
        }
        privateIpAllocationMethod: 'Dynamic'
      }
    ]
  }
}
