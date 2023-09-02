#!/usr/bin/env bash

create_resource_group_temporal() {
    az group create \
      --name $RESOURCE_GROUP_TEMP \
      --location $REGION_US \
      --output none
    echo "Created resource group $RESOURCE_GROUP_TEMP"
}

create_app_service_plan() {
  az appservice plan create \
    --name $APP_PLAN_US \
    --resource-group $RESOURCE_GROUP_TEMP \
    --location $REGION_US \
    --is-linux \
    --sku S1
}

create_app_insights() {
  az monitor app-insights component create \
    --resource-group $RESOURCE_GROUP_TEMP \
    --app $APP_INSIGHTS \
    --location $REGION_US
}

create_web_apps() {
  az webapp create \
    --resource-group $RESOURCE_GROUP_TEMP \
    --plan $APP_PLAN_US \
    --name $BE_WEB_APP_PET \
    --deployment-container-image-name $CONTAINER_REGISTRY.azurecr.io/$BE_WEB_APP_PET:latest \
    --output none

  az webapp create \
    --resource-group $RESOURCE_GROUP_TEMP \
    --plan $APP_PLAN_US \
    --name $BE_WEB_APP_PRODUCT \
    --deployment-container-image-name $CONTAINER_REGISTRY.azurecr.io/$BE_WEB_APP_PRODUCT:latest \
    --output none

  az webapp create \
    --resource-group $RESOURCE_GROUP_TEMP \
    --plan $APP_PLAN_US \
    --name $BE_WEB_APP_ORDER \
    --deployment-container-image-name $CONTAINER_REGISTRY.azurecr.io/$BE_WEB_APP_ORDER:latest \
    --output none

  az webapp create \
      --resource-group $RESOURCE_GROUP_TEMP \
      --plan $APP_PLAN_US \
      --name $MAIN_WEB_APP \
      --deployment-container-image-name $CONTAINER_REGISTRY.azurecr.io/$MAIN_WEB_APP:latest \
      --output none
}

add_env_variables_to_web_apps() {
  az webapp config appsettings set \
    --name $BE_WEB_APP_PET \
    --resource-group $RESOURCE_GROUP_TEMP \
    --settings PET_DB_URI=$PET_DB_URI \
    PET_DB_USERNAME=$POSTGRES_USER \
    PET_DB_PASSWORD=$POSTGRES_PASSWORD \
    APPLICATIONINSIGHTS_CONNECTION_STRING=$APP_INSIGHTS_CONNECTION_STRING \
    --output none

  az webapp config appsettings set \
    --name $BE_WEB_APP_PRODUCT \
    --resource-group $RESOURCE_GROUP_TEMP \
    --settings PRODUCT_DB_URI=$PRODUCT_DB_URI \
    PRODUCT_DB_USERNAME=$POSTGRES_USER \
    PRODUCT_DB_PASSWORD=$POSTGRES_PASSWORD \
    APPLICATIONINSIGHTS_CONNECTION_STRING=$APP_INSIGHTS_CONNECTION_STRING \
    --output none

  az webapp config appsettings set \
    --name $BE_WEB_APP_ORDER \
    --resource-group $RESOURCE_GROUP_TEMP \
    --settings PETSTOREPRODUCTSERVICE_URL=$PETSTOREPRODUCTSERVICE_URL \
    COSMOS_DB_ENDPOINT=$COSMOS_DB_ENDPOINT \
    COSMOS_DB_KEY=$COSMOS_DB_KEY \
    COSMOS_DB_DATABASE=$COSMOS_DB_DATABASE \
    APPLICATIONINSIGHTS_CONNECTION_STRING=$APP_INSIGHTS_CONNECTION_STRING \
    --output none

  az webapp config appsettings set \
    --name $MAIN_WEB_APP \
    --resource-group $RESOURCE_GROUP_TEMP \
    --settings PETSTOREPETSERVICE_URL=$PETSTOREPETSERVICE_URL \
    PETSTOREPRODUCTSERVICE_URL=$PETSTOREPRODUCTSERVICE_URL \
    PETSTOREORDERSERVICE_URL=$PETSTOREORDERSERVICE_URL \
    PETSTORE_ORDER_ITEMS_RESERVER_URL=$PETSTORE_ORDER_ITEMS_RESERVER_URL \
    APPLICATIONINSIGHTS_CONNECTION_STRING=$APP_INSIGHTS_CONNECTION_STRING \
    --output none
}

restart_web_apps() {
  az webapp restart \
    --name $BE_WEB_APP_PET \
    --resource-group $RESOURCE_GROUP_TEMP \
    --output none

  az webapp restart \
    --name $BE_WEB_APP_PRODUCT \
    --resource-group $RESOURCE_GROUP_TEMP \
    --output none

  az webapp restart \
    --name $BE_WEB_APP_ORDER \
    --resource-group $RESOURCE_GROUP_TEMP \
    --output none

  az webapp restart \
    --name $MAIN_WEB_APP \
    --resource-group $RESOURCE_GROUP_TEMP \
    --output none
}

change_web_app_container() {
  az webapp config container set \
    --docker-custom-image-name $CONTAINER_REGISTRY.azurecr.io/$MAIN_WEB_APP:$1 \
    --name $MAIN_WEB_APP \
    --resource-group $RESOURCE_GROUP_TEMP
}

enable_main_app_container_ci_cd() {
  az webapp deployment container config \
    --enable-cd true \
    --name $MAIN_WEB_APP \
    --resource-group $RESOURCE_GROUP_TEMP
}


RESOURCE_GROUP_TEMP=learn-azure-temporal
REGION_US=eastus
APP_PLAN_US=learn-azure-webapp-plan

MAIN_WEB_APP=petstore-app
BE_WEB_APP_PET=petstore-pet-service
BE_WEB_APP_PRODUCT=petstore-product-service
BE_WEB_APP_ORDER=petstore-order-service

CONTAINER_REGISTRY=amazingregistry

PETSTOREPETSERVICE_URL="https://petstore-pet-service.azurewebsites.net"
PETSTOREPRODUCTSERVICE_URL="https://petstore-product-service.azurewebsites.net"
PETSTOREORDERSERVICE_URL="https://petstore-order-service.azurewebsites.net"
PETSTORE_ORDER_ITEMS_RESERVER_URL="https://petstore-reserve-order-items-1.azurewebsites.net"

APP_INSIGHTS=petstore-app-insights
APP_INSIGHTS_CONNECTION_STRING=#<replace-me> # TODO replace after App Insights creation

# databases: 'petstore_pet_db' and 'petstore_product_db'
PET_DB_URI=#<replace-me> # TODO replace after PostgreSQL database creation
PRODUCT_DB_URI=#<replace-me> # TODO replace after PostgreSQL database creation
POSTGRES_USER=#<replace-me> # TODO replace after PostgreSQL server creation
POSTGRES_PASSWORD=#<replace-me> # TODO replace after PostgreSQL server creation

COSMOS_DB_ENDPOINT=#<replace-me> # TODO replace after Cosmos DB account creation
COSMOS_DB_KEY=#<replace-me> # TODO replace after Cosmos DB account creation
COSMOS_DB_DATABASE=petstore-order-cache

create_resource_group_temporal
create_app_insights
create_app_service_plan

# TODO: Add values to environment variables

create_web_apps
add_env_variables_to_web_apps
restart_web_apps

#change_web_app_container v3
#enable_main_app_container_ci_cd
