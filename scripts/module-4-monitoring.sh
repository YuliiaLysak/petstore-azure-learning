#!/usr/bin/env bash

source 00-variables.sh

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
    --deployment-container-image-name $CONTAINER_REGISTRY.azurecr.io/$BE_WEB_APP_PRODUCT:latest

  az webapp create \
    --resource-group $RESOURCE_GROUP_TEMP \
    --plan $APP_PLAN_US \
    --name $BE_WEB_APP_ORDER \
    --deployment-container-image-name $CONTAINER_REGISTRY.azurecr.io/$BE_WEB_APP_ORDER:latest

  az webapp create \
      --resource-group $RESOURCE_GROUP_TEMP \
      --plan $APP_PLAN_US \
      --name $MAIN_WEB_APP \
      --deployment-container-image-name $CONTAINER_REGISTRY.azurecr.io/$MAIN_WEB_APP:latest
}

add_env_variables_to_web_apps() {
  az webapp config appsettings set \
    --name $BE_WEB_APP_PET \
    --resource-group $RESOURCE_GROUP_TEMP \
    --settings APPLICATIONINSIGHTS_CONNECTION_STRING=$APP_INSIGHTS_CONNECTION_STRING \
    --output none

  az webapp config appsettings set \
    --name $BE_WEB_APP_PRODUCT \
    --resource-group $RESOURCE_GROUP_TEMP \
    --settings APPLICATIONINSIGHTS_CONNECTION_STRING=$APP_INSIGHTS_CONNECTION_STRING \
    --output none

  az webapp config appsettings set \
    --name $BE_WEB_APP_ORDER \
    --resource-group $RESOURCE_GROUP_TEMP \
    --settings APPLICATIONINSIGHTS_CONNECTION_STRING=$APP_INSIGHTS_CONNECTION_STRING \
    PETSTOREPRODUCTSERVICE_URL=$PETSTOREPRODUCTSERVICE_URL \
    --output none

  az webapp config appsettings set \
    --name $MAIN_WEB_APP \
    --resource-group $RESOURCE_GROUP_TEMP \
    --settings APPLICATIONINSIGHTS_CONNECTION_STRING=$APP_INSIGHTS_CONNECTION_STRING \
    PETSTOREPETSERVICE_URL=$PETSTOREPETSERVICE_URL \
    PETSTOREPRODUCTSERVICE_URL=$PETSTOREPRODUCTSERVICE_URL \
    PETSTOREORDERSERVICE_URL=$PETSTOREORDERSERVICE_URL \
    --output none
}

restart_web_apps() {
  az webapp restart \
    --name $BE_WEB_APP_PET \
    --resource-group $RESOURCE_GROUP_TEMP \
    --output none

  az webapp restart \
    --name $BE_WEB_APP_ORDER \
    --resource-group $RESOURCE_GROUP_TEMP \
    --output none

  az webapp restart \
    --name $BE_WEB_APP_PRODUCT \
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

#create_resource_group_temporal
#create_app_service_plan
#create_web_apps
#add_env_variables_to_web_apps
#restart_web_apps
#create_app_insights

change_web_app_container v3
