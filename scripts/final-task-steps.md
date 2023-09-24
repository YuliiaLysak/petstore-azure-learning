# Steps

## Permanent resource group
see [00-permanent-resources.sh](./00-permanent-resource-group.sh)


## Temporal resource group
see [00-temporal-resources.sh](./00-temporal-resource-group.sh)


## Key Vault
see [module-7-key-vault.sh](./module-7-key-vault.sh)
1. Create Key Vault instance
2. Add secrets to it (see next steps)
3. Set policy for identities (for App Services to access secrets from Key Vault via env variables)


## Authentication (Active Directory / Microsoft Entra ID)
1. [Create a new tenant in Microsoft Entra ID](https://learn.microsoft.com/en-us/azure/active-directory/fundamentals/create-new-tenant) 
2. Configure petstoreapp application (specific one or traffic manager profile ??? ) - [Tutorial for Spring app](https://learn.microsoft.com/en-us/azure/developer/java/spring-framework/configure-spring-boot-starter-java-app-with-azure-active-directory-b2c-oidc)
3. Add secrets to Key Vault (AD B2C client id, client secret)


## App Service Plan and Application Insights
see [module-4-monitoring.sh](./module-4-monitoring.sh)
1. Create App Service Plan (the same as for App Services)
2. Create App Insights 
3. Add App Insights connection string to variable in [00-variables.sh](./00-variables.sh)


## PostgreSQL
see [module-6-postgres.sh](./module-6-postgres.sh)
1. Create Server
2. Create Firewall rule. If rule wasn't created via script - add it via Azure Portal - see [configure-a-firewall-rule-for-your-postgresql-server](https://learn.microsoft.com/en-us/azure/developer/java/spring-framework/configure-spring-data-jpa-with-azure-postgresql?toc=%2Fazure%2Fpostgresql%2Ftoc.json&bc=%2Fazure%2Fbread%2Ftoc.json&tabs=passwordless%2Cservice-connector&pivots=postgresql-passwordless-single-server#configure-a-firewall-rule-for-your-postgresql-server)
3. Create Databases inside postges server (e.g. via Intellij IDEA Database)
4. Add secrets to Key Vault (DBs uri, username, password)


## Cosmos DB
see [module-6-cosmos-db.sh](./module-6-cosmos-db.sh)
1. Create account
2. Create database
3. Create container (optionally)
4. Add secrets to Key Vault (DB uri, key)


## Service Bus
see [module-8-service-bus.sh](./module-8-service-bus.sh)
1. Create namespace
2. Create queue
3. Add connection string to variable (for Function - 'AzureWebJobsServiceBus' env variable; LogicApp)
4. Assign needed roles for accessing Service Bus (Function - read message, Order Service - send message) - see [00-identities-and-roles.sh](./00-identities-and-roles.sh)


## Logic App
Create manually using Azure Portal  


## Blob Storage
see [module-5-blob-storage.sh](./module-5-blob-storage.sh)
1. Create storage account
2. Create container
3. Assign needed roles for accessing Storage (Function - write files) - see [00-identities-and-roles.sh](./00-identities-and-roles.sh)


## Function App
see [module-5-function-app.sh](./module-5-function-app.sh)  
see [module-5-steps.md](./module-5-steps.md)
1. Deploy Function via maven plugin (from `./petstore/orderitemsreserver`)
2. Enabled systemAssigned identity
3. Assign needed roles to function (Service Bus - read messages, Blob Storage - write files) - see [00-identities-and-roles.sh](./00-identities-and-roles.sh)
4. Add 'AzureWebJobsServiceBus' to Function App settings (Service Bus connection string)
5. Restart Function App if needed


## Container Registry and Docker images
see [01-build-docker-images.sh](./01-build-docker-images.sh)
1. Create container registry
2. Build new Docker images or update existing, if needed


## App Services
see [02-create-web-apps.sh](./02-create-web-apps.sh)
1. Create App Service Plan (the same as for App Insights)
2. Create App Services
3. Enabled systemAssigned identities
4. Assign Key Vault policies to identities (to access secrets from KeyVault via env variables)
5. Assign needed roles to identities (Order Service - write messages to Service Bus) - see [00-identities-and-roles.sh](./00-identities-and-roles.sh)
6. Set environment variables (app insights, postgres, cosmos etc)
7. Restart Apps


## Traffic Manager
see [module-3-traffic-manager.sh](./module-3-traffic-manager.sh)
1. Create traffic manager profile
2. Create endpoints for US and UK
