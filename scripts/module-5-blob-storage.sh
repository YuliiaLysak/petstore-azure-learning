#!/usr/bin/env bash

source 00-variables.sh

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

create_blob_storage_account $RESOURCE_GROUP_PERM
create_storage_container
