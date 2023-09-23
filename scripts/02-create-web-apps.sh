#!/usr/bin/env bash

source 00-variables.sh

create_app_service_plan() {
  az appservice plan create \
    --name $APP_PLAN_US \
    --resource-group $RESOURCE_GROUP_TEMP \
    --location $REGION_US \
    --is-linux \
    --sku S1
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

enable_system_identity_on_web_apps() {
  az webapp identity assign \
    --resource-group $RESOURCE_GROUP_TEMP \
    --name $BE_WEB_APP_PET
  echo "Enabled systemAssigned identity for $BE_WEB_APP_PET"

  az webapp identity assign \
    --resource-group $RESOURCE_GROUP_TEMP \
    --name $BE_WEB_APP_PRODUCT
  echo "Enabled systemAssigned identity for $BE_WEB_APP_PRODUCT"

  az webapp identity assign \
    --resource-group $RESOURCE_GROUP_TEMP \
    --name $BE_WEB_APP_ORDER
  echo "Enabled systemAssigned identity for $BE_WEB_APP_ORDER"

  az webapp identity assign \
    --resource-group $RESOURCE_GROUP_TEMP \
    --name $MAIN_WEB_APP
  echo "Enabled systemAssigned identity for $MAIN_WEB_APP"
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
    SERVICE_BUS_NAMESPACE_NAME=$SERVICE_BUS_NAMESPACE_NAME \
    SERVICE_BUS_QUEUE_NAME=$SERVICE_BUS_QUEUE_NAME \
    APPLICATIONINSIGHTS_CONNECTION_STRING=$APP_INSIGHTS_CONNECTION_STRING \
    --output none

  az webapp config appsettings set \
    --name $MAIN_WEB_APP \
    --resource-group $RESOURCE_GROUP_TEMP \
    --settings PETSTOREPETSERVICE_URL=$PETSTOREPETSERVICE_URL \
    PETSTOREPRODUCTSERVICE_URL=$PETSTOREPRODUCTSERVICE_URL \
    PETSTOREORDERSERVICE_URL=$PETSTOREORDERSERVICE_URL \
    PETSTOREAPP_URL=$PETSTOREAPP_URL \
    AD_B2C_CLIENT_ID=$AD_B2C_CLIENT_ID \
    AD_B2C_CLIENT_SECRET=$AD_B2C_CLIENT_SECRET \
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

create_app_service_plan
create_web_apps
enable_system_identity_on_web_apps
add_env_variables_to_web_apps
restart_web_apps

#change_web_app_container v3
#enable_main_app_container_ci_cd
