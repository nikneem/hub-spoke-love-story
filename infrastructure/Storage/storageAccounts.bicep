param location string
param defaultResourceName string

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: uniqueString('${defaultResourceName}')
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  resource storageAccountTableService 'tableServices@2022-09-01' = {
    name: 'default'
    resource table 'tables' = {
      name: 'apivalues'
    }
  }
}

output storageAccountName string = storageAccount.name
