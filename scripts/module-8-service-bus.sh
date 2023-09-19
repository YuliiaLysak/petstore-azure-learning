#!/usr/bin/env bash

source 00-variables.sh

create_service_bus_namespace() {
  az servicebus namespace create \
    --resource-group $1 \
    --name $SERVICE_BUS_NAMESPACE_NAME \
    --location $REGION_US \
    --sku Basic
#    --sku Standard
}

create_service_bus_queue() {
  az servicebus queue create \
    --name $SERVICE_BUS_QUEUE_NAME \
    --namespace-name $SERVICE_BUS_NAMESPACE_NAME \
    --resource-group $1
}

get_service_bus_connection_string() {
  az servicebus namespace authorization-rule keys list \
      --resource-group $1 \
      --name RootManageSharedAccessKey \
      --query primaryConnectionString \
      --output tsv \
      --namespace-name $SERVICE_BUS_NAMESPACE_NAME

#Endpoint=sb://salesteamappcontoso666.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=++zaYLTgHXH5i1Alx/Og3tKlncv9m0uTZ+ASbCbZrco=
}

create_service_bus_namespace $RESOURCE_GROUP_TEMP
create_service_bus_queue $RESOURCE_GROUP_TEMP
get_service_bus_connection_string $RESOURCE_GROUP_TEMP
