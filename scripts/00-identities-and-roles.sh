#!/usr/bin/env bash

source 00-variables.sh

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

assign_role_for_key_vault_access() {
  az role assignment create \
      --role "Key Vault Secrets User" \
      --assignee $2 \
      --scope "/subscriptions/$SUBSCRIPTION/resourceGroups/$1/providers/Microsoft.KeyVault/vaults/$KEY_VAULT_NAME"
}

assign_role_for_blob_storage_access $RESOURCE_GROUP_PERM my-email@email.com

# Function App
assign_role_for_blob_storage_access $RESOURCE_GROUP_PERM $FUNCTION_SYSTEM_ASSIGNED_IDENTITY_ID
assign_role_for_service_bus_access $RESOURCE_GROUP_TEMP $FUNCTION_SYSTEM_ASSIGNED_IDENTITY_ID

# App Service
assign_role_for_service_bus_access $RESOURCE_GROUP_TEMP $BE_WEB_APP_ORDER_PRINCIPAL_ID

#assign_role_for_key_vault_access $RESOURCE_GROUP_PERM 'replace-me'
