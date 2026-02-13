# Azure SQL Server Bicep Template

This repository contains a Bicep template for deploying an Azure SQL Server with a database and failover group for high availability.

## Resources Deployed

- **Primary SQL Server** - The main Azure SQL Server
- **SQL Database** - A General Purpose database with 2 vCores (GP_Gen5_2 SKU)
- **Secondary SQL Server** - A secondary server in a different region for disaster recovery
- **Failover Group** - Automatic failover configuration between primary and secondary servers

## Prerequisites

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed
- [Bicep CLI](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install) installed (or use `az bicep install`)
- An Azure subscription
- A resource group created in Azure

## Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `sqlServerName` | Yes | The name of the primary SQL Server (must be globally unique) |
| `aadAdminLogin` | Yes | The Azure AD admin login name (e.g., user@domain.com or group name) |
| `aadAdminObjectId` | Yes | The Azure AD admin object ID (GUID) |
| `databaseName` | Yes | The name of the SQL Database |
| `secondarySqlServerName` | Yes | The name of the secondary SQL Server (must be globally unique) |
| `secondaryLocation` | Yes | Azure region for the secondary SQL Server |
| `failoverGroupName` | Yes | The name of the failover group |
| `location` | No | Azure region for primary server (defaults to resource group location) |
| `tags` | No | Resource tags as an object |

## Deployment

### 1. Login to Azure

```bash
az login
```

### 2. Set your subscription (if you have multiple)

```bash
az account set --subscription "<your-subscription-id>"
```

### 3. Create a resource group (if needed)

```bash
az group create --name <resource-group-name> --location <location>
```

### 4. Deploy the Bicep template

```bash
az deployment group create \
  --resource-group <resource-group-name> \
  --template-file main.bicep \
  --parameters sqlServerName=<unique-server-name> \
               aadAdminLogin=<aad-admin-login> \
               aadAdminObjectId=<aad-admin-object-id> \
               databaseName=<database-name> \
               secondarySqlServerName=<secondary-server-name> \
               secondaryLocation=<secondary-region> \
               failoverGroupName=<failover-group-name>
```

### Example

```bash
az deployment group create \
  --resource-group my-rg \
  --template-file main.bicep \
  --parameters sqlServerName=mysqlserver-primary \
               aadAdminLogin=user@domain.com \
               aadAdminObjectId=00000000-0000-0000-0000-000000000000 \
               databaseName=mydb \
               secondarySqlServerName=mysqlserver-secondary \
               secondaryLocation=northeurope \
               failoverGroupName=myfailovergroup
```

## Outputs

After successful deployment, the following outputs are available:

- `sqlServerFqdn` - The fully qualified domain name of the primary SQL Server
- `sqlServerId` - The resource ID of the primary SQL Server
- `sqlDatabaseId` - The resource ID of the SQL Database
- `secondarySqlServerId` - The resource ID of the secondary SQL Server
- `failoverGroupId` - The resource ID of the failover group

## Security Features

- Minimum TLS version set to 1.2
- Azure AD-only authentication enabled (no SQL authentication)
- Azure AD admin configured as the server administrator

## High Availability

The failover group provides:

- **Automatic failover** with a 60-minute grace period for data loss
- **Read-only endpoint** can be enabled for read scale-out
- **Geo-replication** of the database to the secondary server

## Dev Container

This repository includes a dev container configuration that automatically installs:
- Azure CLI
- Bicep CLI
- Bicep VS Code extension

When using GitHub Codespaces or VS Code Dev Containers, all tools will be pre-configured.
testing creation of Azure SQL Server and Failover Group
