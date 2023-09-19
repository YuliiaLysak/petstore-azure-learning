#!/usr/bin/env bash

source 00-variables.sh

create_resource_group_permanent() {
    az group create \
      --name $RESOURCE_GROUP_PERM \
      --location $REGION_US
    echo "Created resource group $RESOURCE_GROUP_PERM"
}

delete_resource_group_permanent() {
  az group delete \
    --name $RESOURCE_GROUP_PERM \
    --yes
}

create_resource_group_permanent
#delete_resource_group_permanent
