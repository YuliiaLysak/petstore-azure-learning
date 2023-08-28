# Steps

## Prepare blob storage
Create Storage Account and Container in it - see [module-5-functions-and-storage.sh](./module-5-functions-and-storage.sh)

## Create Function App - petstore/orderitemsreserver
- Build and run Function locally
```
cd ~/petstore/orderitemsreserver
mvn clean package azure-functions:run
```
- Build and deploy Function app to Azure
```
cd ~/petstore/orderitemsreserver
mvn clean package azure-functions:deploy
```
Tutorial - [Spring Cloud Function in Azure](https://learn.microsoft.com/en-us/azure/developer/java/spring-framework/getting-started-with-spring-cloud-function-in-azure)


## Enable managed identity on Function app
Identity -> System Assigned -> On  
Tutorial - [Access Blob Storage from Function App](https://learn.microsoft.com/en-us/azure/app-service/scenario-secure-app-access-storage?tabs=azure-portal)


## Grant roles to Function
Grant `Storage Blob Data Contributor` role to the Function by identity id - see [module-5-functions-and-storage.sh](./module-5-functions-and-storage.sh)


## Update main web app
Build new Docker image for main WebApp (petstoreapp) - see [01-build-docker-images.sh](./01-build-docker-images.sh)


## Deploy WebApps to Azure
Deploy Web Apps.
Set environment variables.
Restart

see [02-create-web-apps.sh](./02-create-web-apps.sh)