#!/usr/bin/env bash

source 00-variables.sh

create_resource_group_temporal() {
  az group create \
    --name $RESOURCE_GROUP_TEMP \
    --location $REGION_US \
    --output none
  echo "Created resource group $RESOURCE_GROUP_TEMP"
}

create_key_vault() {
  az keyvault create \
    --resource-group $1 \
    --location $REGION_US \
    --name $KEY_VAULT_NAME
  echo "Created Key Vault $KEY_VAULT_NAME"
}

add_secret_to_key_vault() {
  az keyvault secret set \
    --name $1 \
    --value $2 \
    --vault-name $KEY_VAULT_NAME
  echo "Added secret to Key Vault $KEY_VAULT_NAME"
}

show_secret_from_key_vault() {
  az keyvault secret show \
    --name $1 \
    --vault-name $KEY_VAULT_NAME \
    --query "value"
}

enable_system_identity_on_web_apps() {
  az webapp identity assign \
    --resource-group $RESOURCE_GROUP_TEMP \
    --name $BE_WEB_APP_PET
  echo "Enabled systemAssigned identity for $BE_WEB_APP_PET"

  az webapp identity assign \
    --resource-group $RESOURCE_GROUP_TEMP \
    --name $BE_WEB_APP_PRODUCT
  echo "Enabled systemAssigned identity for $BE_WEB_APP_PRODUCT"

  az webapp identity assign \
    --resource-group $RESOURCE_GROUP_TEMP \
    --name $BE_WEB_APP_ORDER
  echo "Enabled systemAssigned identity for $BE_WEB_APP_ORDER"

  az webapp identity assign \
    --resource-group $RESOURCE_GROUP_TEMP \
    --name $MAIN_WEB_APP
  echo "Enabled systemAssigned identity for $MAIN_WEB_APP"
}

key_vault_set_policy_for_identity() {
  az keyvault set-policy \
    --secret-permissions get list \
    --name $KEY_VAULT_NAME \
    --object-id $1
}


# Or assign role for keyVault/appService
assign_role_for_key_vault_access() {
  az role assignment create \
      --role "Key Vault Secrets User" \
      --assignee $2 \
      --scope "/subscriptions/$SUBSCRIPTION/resourceGroups/$1/providers/Microsoft.KeyVault/vaults/$KEY_VAULT_NAME"
}

create_resource_group_temporal
create_key_vault $RESOURCE_GROUP_PERM

add_secret_to_key_vault app-insights-connection $APP_INSIGHTS_CONNECTION_STRING_SECRET

add_secret_to_key_vault pet-db-uri $PET_DB_URI_SECRET
add_secret_to_key_vault product-db-uri $PRODUCT_DB_URI_SECRET
add_secret_to_key_vault postgres-user $POSTGRES_USER_SECRET
add_secret_to_key_vault postgres-password $POSTGRES_PASSWORD_SECRET
add_secret_to_key_vault cosmos-db-endpoint $COSMOS_DB_ENDPOINT_SECRET
add_secret_to_key_vault cosmos-db-key $COSMOS_DB_KEY_SECRET

enable_system_identity_on_web_apps
# TODO: fill variables

key_vault_set_policy_for_identity $BE_WEB_APP_PET_PRINCIPAL_ID
key_vault_set_policy_for_identity $BE_WEB_APP_PRODUCT_PRINCIPAL_ID
key_vault_set_policy_for_identity $BE_WEB_APP_ORDER_PRINCIPAL_ID
key_vault_set_policy_for_identity $MAIN_WEB_APP_PRINCIPAL_ID

#assign_role_for_key_vault_access $RESOURCE_GROUP_PERM 'replace-me'

#show_secret_from_key_vault pet-db-uri
