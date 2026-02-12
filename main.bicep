@description('The name of the SQL Server')
param sqlServerName string

@description('The Azure region for the SQL Server')
param location string = resourceGroup().location

@description('The administrator login for the SQL Server')
param administratorLogin string

@description('The administrator password for the SQL Server')
@secure()
param administratorLoginPassword string

@description('Tags for the SQL Server')
param tags object = {}

@description('The name of the SQL Database')
param databaseName string

resource sqlServer 'Microsoft.Sql/servers@2023-05-01-preview' = {
  name: sqlServerName
  location: location
  tags: tags
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    version: '12.0'
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2023-05-01-preview' = {
  parent: sqlServer
  name: databaseName
  location: location
  tags: tags
  sku: {
    name: 'GP_Gen5_2'
    tier: 'GeneralPurpose'
    family: 'Gen5'
    capacity: 2
  }
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 34359738368
  }
}

@description('The fully qualified domain name of the SQL Server')
output sqlServerFqdn string = sqlServer.properties.fullyQualifiedDomainName

@description('The resource ID of the SQL Server')
output sqlServerId string = sqlServer.id

@description('The resource ID of the SQL Database')
output sqlDatabaseId string = sqlDatabase.id
