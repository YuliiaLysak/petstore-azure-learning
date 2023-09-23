#!/usr/bin/env bash

RESOURCE_GROUP_PERM=learn-azure-permanent
RESOURCE_GROUP_TEMP=learn-azure-temporal
REGION_US=eastus
CONTAINER_REGISTRY=amazingregistry
SUBSCRIPTION='replace-me'


# AppServices
APP_PLAN_US=learn-azure-webapp-plan
MAIN_WEB_APP=petstore-app
BE_WEB_APP_PET=petstore-pet-service
BE_WEB_APP_PRODUCT=petstore-product-service
BE_WEB_APP_ORDER=petstore-order-service

# SystemAssigned identity - principalId / objectId - e.g. "acd2da36-85c5-4d5c-bfec-b48f9f2064dd"
MAIN_WEB_APP_PRINCIPAL_ID='replace-me'
BE_WEB_APP_ORDER_PRINCIPAL_ID='replace-me'
BE_WEB_APP_PET_PRINCIPAL_ID='replace-me'
BE_WEB_APP_PRODUCT_PRINCIPAL_ID='replace-me'

PETSTOREPETSERVICE_URL="https://petstore-pet-service.azurewebsites.net"
PETSTOREPRODUCTSERVICE_URL="https://petstore-product-service.azurewebsites.net"
PETSTOREORDERSERVICE_URL="https://petstore-order-service.azurewebsites.net"
PETSTOREAPP_URL="https://petstore-app.azurewebsites.net"

# Key Vault
KEY_VAULT_NAME=petstore-key-vault


# Application Insights
APP_INSIGHTS=petstore-app-insights
# connection string e.g. "InstrumentationKey=c07f420b-5dfd-4709-99a2-871deb2e668f;IngestionEndpoint=https://eastus-2.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus.livediagnostics.monitor.azure.com/"
APP_INSIGHTS_CONNECTION_STRING_SECRET='replace-me'
APP_INSIGHTS_CONNECTION_STRING='@Microsoft.KeyVault(VaultName=petstore-key-vault;SecretName=app-insights-connection)'


# PostgresSQL  -> databases: 'petstore_pet_db' and 'petstore_product_db'
POSTGRES_SERVER_NAME=petstore-postgres-server
FIREWALL_NAME=AllowIps

PET_DB_URI_SECRET='replace-me'
PET_DB_URI='@Microsoft.KeyVault(VaultName=petstore-key-vault;SecretName=pet-db-uri)'

PRODUCT_DB_URI_SECRET='replace-me'
PRODUCT_DB_URI='@Microsoft.KeyVault(VaultName=petstore-key-vault;SecretName=product-db-uri)'

POSTGRES_USER_VALUE='replace-me'
POSTGRES_USER_SECRET="$POSTGRES_USER_VALUE@$POSTGRES_SERVER_NAME"
POSTGRES_USER='@Microsoft.KeyVault(VaultName=petstore-key-vault;SecretName=postgres-user)'

POSTGRES_PASSWORD_VALUE='replace-me'
POSTGRES_PASSWORD_SECRET="$POSTGRES_PASSWORD_VALUE"
POSTGRES_PASSWORD='@Microsoft.KeyVault(VaultName=petstore-key-vault;SecretName=postgres-password)'


# Cosmos DB
COSMOS_DB_ENDPOINT_SECRET='replace-me'
COSMOS_DB_ENDPOINT='@Microsoft.KeyVault(VaultName=petstore-key-vault;SecretName=cosmos-db-endpoint)'

COSMOS_DB_KEY_SECRET='replace-me'
COSMOS_DB_KEY='@Microsoft.KeyVault(VaultName=petstore-key-vault;SecretName=cosmos-db-key)'

COSMOS_DB_ACCOUNT_NAME=petstore-cosmos-account
COSMOS_DB_DATABASE=petstore-orders-cache
COSMOS_DB_DATABASE_CONTAINER_NAME=orders
COSMOS_DB_DATABASE_CONTAINER_PARTITION_KEY=/email


# Blob Storage
BLOB_STORAGE_NAME=petstorestorage
BLOB_STORAGE_CONTAINER_NAME=reserved-order-items


# Function App
FUNCTION_APP_NAME=petstore-reserve-order-items-1
FUNCTION_APP_PLAN_US=learn-azure-function-plan
FUNCTION_SYSTEM_ASSIGNED_IDENTITY_ID='replace-me'


# Service Bus (queue)
SERVICE_BUS_NAMESPACE_NAME=petstore-orders
SERVICE_BUS_QUEUE_NAME=reserved-order-items


# Active Directory B2C
AD_B2C_CLIENT_ID_VALUE='replace-me'
AD_B2C_CLIENT_ID='@Microsoft.KeyVault(VaultName=petstore-key-vault;SecretName=ad-b2c-client-id)'
AD_B2C_CLIENT_SECRET_VALUE='replace-me'
AD_B2C_CLIENT_SECRET='@Microsoft.KeyVault(VaultName=petstore-key-vault;SecretName=ad-b2c-client-secret)'
