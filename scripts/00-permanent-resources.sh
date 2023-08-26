#!/usr/bin/env bash

create_resource_group_permanent() {
    az group create \
      --name $RESOURCE_GROUP_PERM \
      --location $REGION_US
    echo "Created resource group $RESOURCE_GROUP_PERM"
}

create_container_registry() {
  az acr create \
    --name $CONTAINER_REGISTRY \
    --resource-group $RESOURCE_GROUP_PERM \
    --sku Basic \
    --admin-enabled true
  echo "Created container registry $CONTAINER_REGISTRY"
  az acr login --name $CONTAINER_REGISTRY
}

RESOURCE_GROUP_PERM=learn-azure-permanent
REGION_US=eastus
CONTAINER_REGISTRY=amazingregistry

create_resource_group_permanent
create_container_registry