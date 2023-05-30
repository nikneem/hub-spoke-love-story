param location string = resourceGroup().location

var vpnGatewaySubnetName = 'VpnGateway'

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
        ]
    }
}

output vnetName string = hubVnet.name
output vpnGatewaySubnetName string = vpnGatewaySubnetName

