#!/usr/bin/env bash

source 00-variables.sh

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

key_vault_set_policy_for_identity() {
  az keyvault set-policy \
    --secret-permissions get list \
    --name $KEY_VAULT_NAME \
    --object-id $1
}

create_key_vault $RESOURCE_GROUP_PERM

add_secret_to_key_vault app-insights-connection $APP_INSIGHTS_CONNECTION_STRING_SECRET

add_secret_to_key_vault pet-db-uri $PET_DB_URI_SECRET
add_secret_to_key_vault product-db-uri $PRODUCT_DB_URI_SECRET
add_secret_to_key_vault postgres-user $POSTGRES_USER_SECRET
add_secret_to_key_vault postgres-password $POSTGRES_PASSWORD_SECRET
add_secret_to_key_vault cosmos-db-endpoint $COSMOS_DB_ENDPOINT_SECRET
add_secret_to_key_vault cosmos-db-key $COSMOS_DB_KEY_SECRET

add_secret_to_key_vault ad-b2c-client-id $AD_B2C_CLIENT_ID_VALUE
add_secret_to_key_vault ad-b2c-client-secret $AD_B2C_CLIENT_SECRET_VALUE

key_vault_set_policy_for_identity $BE_WEB_APP_PET_PRINCIPAL_ID
key_vault_set_policy_for_identity $BE_WEB_APP_PRODUCT_PRINCIPAL_ID
key_vault_set_policy_for_identity $BE_WEB_APP_ORDER_PRINCIPAL_ID
key_vault_set_policy_for_identity $MAIN_WEB_APP_PRINCIPAL_ID

#show_secret_from_key_vault pet-db-uri
