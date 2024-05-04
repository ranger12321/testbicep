// Define parameters
@description('The name of the Function App')
param functionAppName string = 'samplefunc${uniqueString(resourceGroup().id)}' // Sample name for the Function App

@description('The location for the Function App')
param location string = resourceGroup().location

@description('The name of the Key Vault')
param keyVaultName string

@description('The connection string for the Storage Account')
param storageConnectionString string

// Create the Function App resource
resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Web/serverfarms/${functionAppName}'
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${split(storageConnectionString, \';\')[1].split(\'=\')[1]};EndpointSuffix=${split(storageConnectionString, \';\')[2].split(\'=\')[1]};AccountKey=${split(storageConnectionString, \';\')[3].split(\'=\')[1]}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: '@Microsoft.KeyVault(SecretUri=https://${keyVaultName}.vault.azure.net/secrets/azurefilesconnectionstring/)'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
      ]
    }
  }
}

// Create a hosting plan for the Function App
resource functionAppHostingPlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: functionAppName
  location: location
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {}
}

// Define access policy for the Function App to access Key Vault secrets
resource keyVaultAccessPolicy 'Microsoft.KeyVault/vaults/accessPolicies@2022-07-01' = {
  name: '${keyVaultName}/add'
  properties: {
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: functionApp.identity.principalId
        permissions: {
          secrets: [
            'get'
          ]
        }
      }
    ]
  }
}
