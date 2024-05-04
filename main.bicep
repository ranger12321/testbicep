// Define parameters
@description('The location for the resources')
param location string = 'eastus' // Sample location for the resources

// Deploy the storage account module
module storageModule 'storage.bicep' = {
  name: 'storageModule'
  params: {
    location: location
  }
}

// Deploy the Key Vault module
module keyVaultModule 'keyvault.bicep' = {
  name: 'keyVaultModule'
  params: {
    location: location
  }
}

// Deploy the Function App module
module functionAppModule 'functionapp.bicep' = {
  name: 'functionAppModule'
  params: {
    location: location
    keyVaultName: keyVaultModule.outputs.keyVaultName
    storageConnectionString: storageModule.outputs.storageConnectionString
  }
}
