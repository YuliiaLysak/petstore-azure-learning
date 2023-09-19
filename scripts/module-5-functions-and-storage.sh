#!/usr/bin/env bash

source 00-variables.sh

create_resource_group_temporal() {
    az group create \
      --name $RESOURCE_GROUP_TEMP \
      --location $REGION_US \
      --output none
    echo "Created resource group $RESOURCE_GROUP_TEMP"
}

create_blob_storage_account() {
  az storage account create \
    --kind StorageV2 \
    --resource-group $1 \
    --location $REGION_US \
    --name $BLOB_STORAGE_NAME \
    --output none
  echo "Created blob storage $BLOB_STORAGE_NAME"
}

create_storage_container() {
  az storage container create \
      --name $BLOB_STORAGE_CONTAINER_NAME \
      --account-name $BLOB_STORAGE_NAME

#       \
#      --auth-mode login
}

enable_function_system_assigned_identity() {
  az functionapp identity assign \
      --resource-group $1 \
      --name $FUNCTION_APP_NAME
}

assign_role_for_blob_storage_access() {
  az role assignment create \
      --role "Storage Blob Data Contributor" \
      --assignee $2 \
      --scope "/subscriptions/$SUBSCRIPTION/resourceGroups/$1/providers/Microsoft.Storage/storageAccounts/$BLOB_STORAGE_NAME/blobServices/default/containers/$BLOB_STORAGE_CONTAINER_NAME"
}

assign_role_for_service_bus_access() {
  az role assignment create \
      --role "Azure Service Bus Data Owner" \
      --assignee $2 \
      --scope "/subscriptions/$SUBSCRIPTION/resourceGroups/$1/providers/Microsoft.ServiceBus/namespaces/$SERVICE_BUS_NAMESPACE_NAME/queues/$SERVICE_BUS_QUEUE_NAME"
}

create_resource_group_temporal
create_blob_storage_account $RESOURCE_GROUP_PERM
create_storage_container

enable_function_system_assigned_identity $RESOURCE_GROUP_TEMP

# TODO: Add 'AzureWebJobsServiceBus' to function app settings


# TODO: Add values in 00-variables.sh

assign_role_for_blob_storage_access $RESOURCE_GROUP_PERM my-email@email.com
assign_role_for_blob_storage_access $RESOURCE_GROUP_PERM $FUNCTION_SYSTEM_ASSIGNED_IDENTITY_ID
assign_role_for_service_bus_access $RESOURCE_GROUP_TEMP $FUNCTION_SYSTEM_ASSIGNED_IDENTITY_ID
assign_role_for_service_bus_access $RESOURCE_GROUP_TEMP $BE_WEB_APP_ORDER_PRINCIPAL_ID