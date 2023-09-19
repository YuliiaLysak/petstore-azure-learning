#!/usr/bin/env bash

source 00-variables.sh

enable_function_system_assigned_identity() {
  az functionapp identity assign \
      --resource-group $1 \
      --name $FUNCTION_APP_NAME
}

enable_function_system_assigned_identity $RESOURCE_GROUP_TEMP

# TODO: Add 'AzureWebJobsServiceBus' to function app settings