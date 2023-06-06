param principalId string
param roleDefinitionId string
@allowed([
  'ServicePrincipal'
  'ForeignGroup'
  'Group'
  'Device'
  'User'
])
param principalType string = 'ServicePrincipal'

resource allowConfigurationDataReader 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid('${principalId}-${roleDefinitionId}')
  properties: {
    principalId: principalId
    principalType: principalType
    roleDefinitionId: roleDefinitionId
  }
}
