#!/usr/bin/env bash

create_resource_group_temporal() {
    az group create \
      --name $RESOURCE_GROUP_TEMP \
      --location $REGION_US \
      --output none
    echo "Created resource group $RESOURCE_GROUP_TEMP"
}

create_cosmos_db_account() {
  az cosmosdb create \
    --name $COSMOS_DB_ACCOUNT_NAME \
    --resource-group $1 \
    --locations regionName=$REGION_US \
    --output none
  echo "Created Cosmos DB account $COSMOS_DB_ACCOUNT_NAME"
}

create_cosmos_db_database() {
  az cosmosdb sql database create \
    --account-name $COSMOS_DB_ACCOUNT_NAME \
    --resource-group $1 \
    --name $COSMOS_DB_DATABASE_NAME \
    --output none
  echo "Created Cosmos DB database $COSMOS_DB_DATABASE_NAME"
}

create_cosmos_db_database_container() {
  az cosmosdb sql container create \
    --account-name $COSMOS_DB_ACCOUNT_NAME \
    --resource-group $1 \
    --database-name $COSMOS_DB_DATABASE_NAME \
    --name $2 \
    --partition-key-path $3 \
    --output none
  echo "Created Cosmos DB container $2 with partition-key $3"
}

RESOURCE_GROUP_TEMP=learn-azure-temporal
RESOURCE_GROUP_PERM=learn-azure-permanent
REGION_US=eastus

COSMOS_DB_ACCOUNT_NAME=petstore-cosmos-account
COSMOS_DB_DATABASE_NAME=petstore-orders-cache
COSMOS_DB_DATABASE_CONTAINER_NAME=orders
COSMOS_DB_DATABASE_CONTAINER_PARTITION_KEY=/email


create_resource_group_temporal
create_cosmos_db_account $RESOURCE_GROUP_PERM
create_cosmos_db_database $RESOURCE_GROUP_PERM
create_cosmos_db_database_container $RESOURCE_GROUP_PERM $COSMOS_DB_DATABASE_CONTAINER_NAME $COSMOS_DB_DATABASE_CONTAINER_PARTITION_KEY
