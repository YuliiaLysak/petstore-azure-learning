# Steps

## Create PostgreSQL Server
Create Server and Firewall rule to it - see [module-6-postgres.sh](./module-6-postgres.sh)  
If rule wasn't created via script - add it via Azure Portal - see [configure-a-firewall-rule-for-your-postgresql-server](https://learn.microsoft.com/en-us/azure/developer/java/spring-framework/configure-spring-data-jpa-with-azure-postgresql?toc=%2Fazure%2Fpostgresql%2Ftoc.json&bc=%2Fazure%2Fbread%2Ftoc.json&tabs=passwordless%2Cservice-connector&pivots=postgresql-passwordless-single-server#configure-a-firewall-rule-for-your-postgresql-server)


## Create Cosmos DB Account, Databases, Container (optionally)
Create resources on Azure - see [module-6-cosmos-db.sh](./module-6-cosmos-db.sh)


## Deploy Function
See [module-5-steps.md](./module-5-steps.md)


## Update Docker images
Build new Docker image for:
- petservice
- productservice
- orderservice  
See [01-build-docker-images.sh](./01-build-docker-images.sh)


## Deploy WebApps to Azure
Deploy Web Apps.
Set environment variables.
Restart

see [02-create-web-apps.sh](./02-create-web-apps.sh)