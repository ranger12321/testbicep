// Define parameters
@description('The name of the Key Vault')
param keyVaultName string = 'samplekv${uniqueString(resourceGroup().id)}' // Sample name for the Key Vault

@description('The location for the Key Vault')
param location string = resourceGroup().location

// Create the Key Vault resource
resource keyVault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: keyVaultName
  location: location
  properties: {
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    enableRbacAuthorization: true
    tenantId: subscription().tenantId
    sku: {
      name: 'standard'
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}

// Define output for Key Vault name
output keyVaultName string = keyVault.name
