#!/usr/bin/env bash

source 00-variables.sh

# TODO: review command
create_logic_app() {
  az logicapp create \
    --name myLogicApp \
    --resource-group $1 \
    --storage-account myStorageAccount \
    -p MyPlan
}

create_logic_app $RESOURCE_GROUP_TEMP
