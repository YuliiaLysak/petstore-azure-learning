#!/usr/bin/env bash

delete_resource_group() {
  az group delete \
    --name $RESOURCE_GROUP_TEMP \
    --yes
}

RESOURCE_GROUP_TEMP=learn-azure-temporal

delete_resource_group