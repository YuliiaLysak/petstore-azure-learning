#!/usr/bin/env bash

source 00-variables.sh

create_resource_group_temporal() {
    az group create \
      --name $RESOURCE_GROUP_TEMP \
      --location $REGION_US \
      --output none
    echo "Created resource group $RESOURCE_GROUP_TEMP"
}

delete_resource_group_temporal() {
  az group delete \
    --name $RESOURCE_GROUP_TEMP \
    --yes
}

create_resource_group_temporal
#delete_resource_group_temporal
