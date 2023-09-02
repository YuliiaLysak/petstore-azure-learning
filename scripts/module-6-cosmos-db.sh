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
    --resource-group $RESOURCE_GROUP_TEMP \
    --locations regionName=$REGION_US \
    --output none
  echo "Created Cosmos DB account $COSMOS_DB_ACCOUNT_NAME"
}

create_cosmos_db_database() {
  az cosmosdb sql database create \
    --account-name $COSMOS_DB_ACCOUNT_NAME \
    --resource-group $RESOURCE_GROUP_TEMP \
    --name $COSMOS_DB_DATABASE_NAME \
    --output none
  echo "Created Cosmos DB database $COSMOS_DB_DATABASE_NAME"
}

create_cosmos_db_database_container() {
  az cosmosdb sql container create \
    --account-name $COSMOS_DB_ACCOUNT_NAME \
    --resource-group $RESOURCE_GROUP_TEMP \
    --database-name $COSMOS_DB_DATABASE_NAME \
    --name $1 \
    --partition-key-path $2 \
    --output none
  echo "Created Cosmos DB container $1 with partition-key $2"
}

RESOURCE_GROUP_TEMP=learn-azure-temporal
REGION_US=eastus

COSMOS_DB_ACCOUNT_NAME=petstore-cosmos-account
COSMOS_DB_DATABASE_NAME=petstore-orders-cache
COSMOS_DB_DATABASE_CONTAINER_NAME=orders
COSMOS_DB_DATABASE_CONTAINER_PARTITION_KEY=/email


create_resource_group_temporal
create_cosmos_db_account
create_cosmos_db_database
create_cosmos_db_database_container $COSMOS_DB_DATABASE_CONTAINER_NAME $COSMOS_DB_DATABASE_CONTAINER_PARTITION_KEY
