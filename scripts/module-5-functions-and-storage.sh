#!/usr/bin/env bash

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
    --resource-group $RESOURCE_GROUP_TEMP \
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

assign_role_for_blob_storage_access() {
  az role assignment create \
      --role "Storage Blob Data Contributor" \
      --assignee $1 \
      --scope "/subscriptions/$SUBSCRIPTION/resourceGroups/$RESOURCE_GROUP_TEMP/providers/Microsoft.Storage/storageAccounts/$BLOB_STORAGE_NAME/blobServices/default/containers/$BLOB_STORAGE_CONTAINER_NAME"
}

RESOURCE_GROUP_TEMP=learn-azure-temporal
REGION_US=eastus

BLOB_STORAGE_NAME=petstorestorage
BLOB_STORAGE_CONTAINER_NAME=reserved-order-items

FUNCTION_APP_PLAN_US=learn-azure-function-plan

SUBSCRIPTION=#<replace-me> # TODO replace with subscription id
FUNCTION_SYSTEM_ASSIGNED_IDENTITY_ID=#<replace-me> # TODO replace with Function System Assigned id

create_resource_group_temporal
create_blob_storage_account
create_storage_container

# TODO: Add values to environment variables

assign_role_for_blob_storage_access my-email@email.com
assign_role_for_blob_storage_access $FUNCTION_SYSTEM_ASSIGNED_IDENTITY_ID
