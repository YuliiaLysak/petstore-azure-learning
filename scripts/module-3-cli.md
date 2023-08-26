# Module 3 - App Services

```shell
export RESOURCE_GROUP=learn-azure
export REGION_US=eastus
export REGION_UK=uksouth
export APP_PLAN_US=ASP-learnazure-a949
export APP_PLAN_UK=ASP-learnazure-uksouth
export MAIN_WEB_APP_US=mypetstoreapp
export MAIN_WEB_APP_UK=mypetstoreapp-uk
export BE_WEB_APP_PET=petstorepetservice
export BE_WEB_APP_PRODUCT=petstoreproductservice
export BE_WEB_APP_ORDER=petstoreorderservice
export CONTAINER_REGISTRY=amazingregistry
export TRAFFIC_MANAGER_PROFILE=petstoretrafficmanagerprofile
```

### Login
```shell
az login
```

### Create resource group
```shell
az group create --name $RESOURCE_GROUP --location $REGION_US
az group list
```

### Create container registry and login to it
```shell
az acr create --name $CONTAINER_REGISTRY --resource-group $RESOURCE_GROUP --sku Basic --admin-enabled true
az acr list
az acr login --name $CONTAINER_REGISTRY
#az acr credential show --resource-group $RESOURCE_GROUP --name $CONTAINER_REGISTRY
```

### Add Docker images to Container Registry

#### Option 1 - Build, tag and push Docker image via 'docker' (if images already built - only push them to registry)
```shell
cd ~/petstore/petstorepetservice
mvn clean package
docker build -t $BE_WEB_APP_PET .
docker tag $BE_WEB_APP_PET:latest $CONTAINER_REGISTRY.azurecr.io/$BE_WEB_APP_PET
docker push $CONTAINER_REGISTRY.azurecr.io/$BE_WEB_APP_PET

cd ~/petstore/petstoreproductservice
mvn clean package
docker build -t $BE_WEB_APP_PRODUCT .
docker tag $BE_WEB_APP_PRODUCT:latest $CONTAINER_REGISTRY.azurecr.io/$BE_WEB_APP_PRODUCT
docker push $CONTAINER_REGISTRY.azurecr.io/$BE_WEB_APP_PRODUCT

cd ~/petstore/petstoreorderservice
mvn clean package
docker build -t $BE_WEB_APP_ORDER .
docker tag $BE_WEB_APP_ORDER:latest $CONTAINER_REGISTRY.azurecr.io/$BE_WEB_APP_ORDER
docker push $CONTAINER_REGISTRY.azurecr.io/$BE_WEB_APP_ORDER

cd ~/petstore/petstoreapp
mvn clean package
docker build -t petstoreapp .
docker tag petstoreapp:latest $CONTAINER_REGISTRY.azurecr.io/petstoreapp
docker push $CONTAINER_REGISTRY.azurecr.io/petstoreapp

az acr repository list --name $CONTAINER_REGISTRY
```

#### Option 2 - Build Docker images via 'az acr'
```shell
cd ~/petstore/petstorepetservice
az acr build --registry $CONTAINER_REGISTRY --image $BE_WEB_APP_PET .
cd ~/petstore/petstoreproductservice
az acr build --registry $CONTAINER_REGISTRY --image $BE_WEB_APP_PRODUCT .
cd ~/petstore/petstoreorderservice
az acr build --registry $CONTAINER_REGISTRY --image $BE_WEB_APP_ORDER .
cd ~/petstore/petstoreapp
az acr build --registry $CONTAINER_REGISTRY --image petstoreapp .
```

### Create App Service Plan
```shell
az appservice plan create \
    --name $APP_PLAN_US \
    --resource-group $RESOURCE_GROUP \
    --location $REGION_US \
    --is-linux \
    --sku S1

az appservice plan create \
    --name $APP_PLAN_UK \
    --resource-group $RESOURCE_GROUP \
    --location $REGION_UK \
    --is-linux \
    --sku S1
    
    
az appservice plan list --output table
```

### Deploy (create web app)

#### Azure Portal

#### WIP  - Azure CLI (need to investigate permissions for pulling images from registry)
```shell
az webapp create --resource-group $RESOURCE_GROUP --plan $APP_PLAN_US --name $BE_WEB_APP_PET --deployment-container-image-name $CONTAINER_REGISTRY.azurecr.io/$BE_WEB_APP_PET:latest
az webapp create --resource-group $RESOURCE_GROUP --plan $APP_PLAN_US --name $BE_WEB_APP_PRODUCT --deployment-container-image-name $CONTAINER_REGISTRY.azurecr.io/$BE_WEB_APP_PRODUCT:latest
az webapp create --resource-group $RESOURCE_GROUP --plan $APP_PLAN_US --name $BE_WEB_APP_ORDER --deployment-container-image-name $CONTAINER_REGISTRY.azurecr.io/$BE_WEB_APP_ORDER:latest

az webapp create \
    --name $MAIN_WEB_APP_US \
    --plan $APP_PLAN_US \
    --resource-group $RESOURCE_GROUP \
    --deployment-container-image-name $CONTAINER_REGISTRY.azurecr.io/petstoreapp:latest

az webapp create \
    --name $MAIN_WEB_APP_UK \
    --plan $APP_PLAN_UK \
    --resource-group $RESOURCE_GROUP \
    --deployment-container-image-name $CONTAINER_REGISTRY.azurecr.io/petstoreapp:latest
```

### Add environment variables to created Web Apps
```shell
az webapp config appsettings set --name $BE_WEB_APP_ORDER --resource-group $RESOURCE_GROUP --settings PETSTOREPRODUCTSERVICE_URL="https://petstoreproductservice.azurewebsites.net"

az webapp config appsettings set --name $MAIN_WEB_APP_US --resource-group $RESOURCE_GROUP --settings PETSTOREPETSERVICE_URL="https://petstorepetservice.azurewebsites.net"
az webapp config appsettings set --name $MAIN_WEB_APP_US --resource-group $RESOURCE_GROUP --settings PETSTOREPRODUCTSERVICE_URL="https://petstoreproductservice.azurewebsites.net"
az webapp config appsettings set --name $MAIN_WEB_APP_US --resource-group $RESOURCE_GROUP --settings PETSTOREORDERSERVICE_URL="https://petstoreorderservice.azurewebsites.net"

az webapp config appsettings set --name $MAIN_WEB_APP_UK --resource-group $RESOURCE_GROUP --settings PETSTOREPETSERVICE_URL="https://petstorepetservice.azurewebsites.net"
az webapp config appsettings set --name $MAIN_WEB_APP_UK --resource-group $RESOURCE_GROUP --settings PETSTOREPRODUCTSERVICE_URL="https://petstoreproductservice.azurewebsites.net"
az webapp config appsettings set --name $MAIN_WEB_APP_UK --resource-group $RESOURCE_GROUP --settings PETSTOREORDERSERVICE_URL="https://petstoreorderservice.azurewebsites.net"


```

### Traffic Manager
```shell
az network traffic-manager profile create \
    --name $TRAFFIC_MANAGER_PROFILE \
    --resource-group $RESOURCE_GROUP \
    --routing-method Priority \
    --path '/' \
    --protocol "HTTPS" \
    --unique-dns-name $TRAFFIC_MANAGER_PROFILE  \
    --ttl 30 \
    --port 80

az network traffic-manager profile show \
    --name $TRAFFIC_MANAGER_PROFILE \
    --resource-group $RESOURCE_GROUP \
    --query dnsConfig.fqdn



App1ResourceId=$(az webapp show --name $MAIN_WEB_APP_US --resource-group $RESOURCE_GROUP --query id --output tsv)
az network traffic-manager endpoint create \
    --name $MAIN_WEB_APP_US \
    --resource-group $RESOURCE_GROUP \
    --profile-name $TRAFFIC_MANAGER_PROFILE \
    --type azureEndpoints \
    --target-resource-id $App1ResourceId \
    --priority 1 \
    --endpoint-status Enabled
    
    
App2ResourceId=$(az webapp show --name $MAIN_WEB_APP_UK --resource-group $RESOURCE_GROUP --query id --output tsv)
az network traffic-manager endpoint create \
    --name $MAIN_WEB_APP_UK \
    --resource-group $RESOURCE_GROUP \
    --profile-name $TRAFFIC_MANAGER_PROFILE \
    --type azureEndpoints \
    --target-resource-id  $App2ResourceId \
    --priority 2 \
    --endpoint-status Enabled
    
    
Disable endpoint:
    
az network traffic-manager endpoint update \
     --name $MAIN_WEB_APP_US \
     --resource-group $RESOURCE_GROUP \
     --profile-name $TRAFFIC_MANAGER_PROFILE \
     --type azureEndpoints \
     --endpoint-status Disabled
```

### Test autoscaling

#### Azure Portal - Add rules fo Autoscale setting (Increase count / Decrease count)

#### Apache Benchmark - load application
```shell
ab -n 5000 -c 50 -k -H "accept: application/json" https://petstorepetservice.azurewebsites.net/petstorepetservice/v2/pet/findByTags?tags=dog
```

### Delete resource group (clean up)
```shell
az group delete --name $RESOURCE_GROUP
```
