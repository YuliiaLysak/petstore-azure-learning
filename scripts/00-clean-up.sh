#!/usr/bin/env bash

source 00-variables.sh

delete_resource_group() {
  az group delete \
    --name $RESOURCE_GROUP_TEMP \
    --yes
}

delete_resource_group