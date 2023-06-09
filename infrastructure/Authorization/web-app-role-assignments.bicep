param webAppservicePrincipalId string

resource storageAccountDataContributorRole 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: resourceGroup()
  name: '0a9a7e1f-b9d0-4cc4-a60d-0319b160aaa3'
}
module storageAccountDataReaderRoleAssignment 'roleAssignment.bicep' = {
  name: 'storageAccountDataReaderRoleAssignmentModule'
  scope: resourceGroup()
  params: {
    principalId: webAppservicePrincipalId
    roleDefinitionId: storageAccountDataContributorRole.id
  }
}
module storageAccountDataReaderRoleAssignmentForEduard 'roleAssignment.bicep' = {
  name: 'storageAccountDataReaderRoleAssignmentForEduardModule'
  scope: resourceGroup()
  params: {
    principalId: 'ce00c98d-c389-47b0-890e-7f156f136ebd'
    roleDefinitionId: storageAccountDataContributorRole.id
    principalType: 'User'
  }
}
