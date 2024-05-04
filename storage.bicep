// Define parameters
@description('The name of the Storage Account')
param storageAccountName string = 'samplestorage${uniqueString(resourceGroup().id)}' // Sample name for the storage account

@description('The location for the Storage Account')
param location string = resourceGroup().location

// Create the Storage Account resource
resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

// Define output for storage connection string
@description('The connection string for the Storage Account')
output storageConnectionString string = 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};EndpointSuffix=${environment().suffixes.storage};AccountKey=${listKeys(storageAccount.id, storageAccount.apiVersion).keys[0].value}'
