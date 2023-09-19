#!/usr/bin/env bash

source 00-variables.sh

create_postgres_server() {
  az postgres server create \
    --name $POSTGRES_SERVER_NAME \
    --resource-group $1 \
    --location $REGION_US \
    --admin-user $POSTGRES_USER_VALUE \
    --admin-password $POSTGRES_PASSWORD_VALUE \
    --sku-name B_Gen5_1
#    --sku-name GP_Gen5_2
#    --backup-retention 30 \
#    todo: try another sku - look for basic B_Gen5_1 ??
}

create_postgres_server_firewall_rule() {
  az postgres server firewall-rule create \
    --resource-group $1 \
    --server $POSTGRES_SERVER_NAME \
    --name $FIREWALL_NAME \
    --start-ip-address 0.0.0.0 \
    --end-ip-address 255.255.255.255
}

# disconnect from the database connection using the \q command
# also try pressing Escape and then press Enter
# alternatively ; then press Enter

# Connect to created postgres server via Intellij IDEA (or psql) using postgres db at first
# TODO: Create 2 databases: petstore_product_db and petstore_pet_db
psql_connect_to_postgres_server() {
  psql \
    --host=petstore-postgres-server.postgres.database.azure.com \
    --port=5432 \
    --username=username@petstore-postgres-server \
    --dbname=postgres

#   create DB
   CREATE DATABASE petstore_product_db;
   CREATE DATABASE petstore_pet_db;
#   connect to created DB
   \c petstore_pet_db
#   disconnect from DB
   \q
}

create_postgres_server $RESOURCE_GROUP_TEMP
create_postgres_server_firewall_rule $RESOURCE_GROUP_TEMP
