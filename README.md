# Azure SQL Server Bicep Template

This repository contains a Bicep template for deploying an Azure SQL Server.

## Prerequisites

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed
- [Bicep CLI](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/install) installed (or use `az bicep install`)
- An Azure subscription
- A resource group created in Azure

## Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `sqlServerName` | Yes | The name of the SQL Server (must be globally unique) |
| `administratorLogin` | Yes | The administrator username for the SQL Server |
| `administratorLoginPassword` | Yes | The administrator password (secure) |
| `location` | No | Azure region (defaults to resource group location) |
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
               administratorLogin=<admin-username> \
               administratorLoginPassword=<secure-password>
```

### Example

```bash
az deployment group create \
  --resource-group my-rg \
  --template-file main.bicep \
  --parameters sqlServerName=mysqlserver123 \
               administratorLogin=sqladmin \
               administratorLoginPassword='P@ssw0rd123!'
```

## Outputs

After successful deployment, the following outputs are available:

- `sqlServerFqdn` - The fully qualified domain name of the SQL Server
- `sqlServerId` - The resource ID of the SQL Server

## Security Features

- Minimum TLS version set to 1.2
- Password parameter marked as secure (not logged in deployment history)

## Dev Container

This repository includes a dev container configuration that automatically installs:
- Azure CLI
- Bicep CLI
- Bicep VS Code extension

When using GitHub Codespaces or VS Code Dev Containers, all tools will be pre-configured.
testing creation of Azure SQL Server and Failover Group
