#!/usr/bin/env bash

source 00-variables.sh

create_traffic_manager() {
  az network traffic-manager profile create \
    --name $TRAFFIC_MANAGER_PROFILE \
    --resource-group $RESOURCE_GROUP_TEMP \
    --routing-method Priority \
    --path '/' \
    --protocol "HTTPS" \
    --unique-dns-name $TRAFFIC_MANAGER_PROFILE  \
    --ttl 30 \
    --port 80
}

show_traffic_manager() {
  az network traffic-manager profile show \
    --name $TRAFFIC_MANAGER_PROFILE \
    --resource-group $RESOURCE_GROUP_TEMP \
    --query dnsConfig.fqdn
}

create_endpoint() {
  az network traffic-manager endpoint create \
    --name "$MAIN_WEB_APP-$1" \
    --resource-group $RESOURCE_GROUP_TEMP \
    --profile-name $TRAFFIC_MANAGER_PROFILE \
    --type azureEndpoints \
    --target-resource-id $2 \
    --priority $3 \
    --endpoint-status Enabled
}

disable_endpoint() {
  az network traffic-manager endpoint update \
   --name "$MAIN_WEB_APP-$1" \
   --resource-group $RESOURCE_GROUP_TEMP \
   --profile-name $TRAFFIC_MANAGER_PROFILE \
   --type azureEndpoints \
   --endpoint-status Disabled
}

create_traffic_manager
show_traffic_manager

MAIN_WEB_APP_US_RESOURCE_ID=$(az webapp show --name "$MAIN_WEB_APP-us" --resource-group $RESOURCE_GROUP_TEMP --query id --output tsv)
create_endpoint "us" $MAIN_WEB_APP_US_RESOURCE_ID 1

MAIN_WEB_APP_UK_RESOURCE_ID=$(az webapp show --name "$MAIN_WEB_APP-uk" --resource-group $RESOURCE_GROUP_TEMP --query id --output tsv)
create_endpoint "uk" $MAIN_WEB_APP_UK_RESOURCE_ID 2

#disable_endpoint "us"
#disable_endpoint "uk"

