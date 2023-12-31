#!/usr/bin/env bash

source 00-variables.sh

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
    --name $COSMOS_DB_DATABASE \
    --output none
  echo "Created Cosmos DB database $COSMOS_DB_DATABASE"
}

create_cosmos_db_database_container() {
  az cosmosdb sql container create \
    --account-name $COSMOS_DB_ACCOUNT_NAME \
    --resource-group $1 \
    --database-name $COSMOS_DB_DATABASE \
    --name $2 \
    --partition-key-path $3 \
    --output none
  echo "Created Cosmos DB container $2 with partition-key $3"
}

get_cosmos_db_key() {
  az cosmosdb keys list \
    --name $COSMOS_DB_ACCOUNT_NAME \
    --resource-group $1 \
    --type keys \
    --query primaryMasterKey \
    --output tsv
}

create_cosmos_db_account $RESOURCE_GROUP_TEMP
create_cosmos_db_database $RESOURCE_GROUP_TEMP
create_cosmos_db_database_container $RESOURCE_GROUP_TEMP $COSMOS_DB_DATABASE_CONTAINER_NAME $COSMOS_DB_DATABASE_CONTAINER_PARTITION_KEY
get_cosmos_db_key $RESOURCE_GROUP_TEMP
