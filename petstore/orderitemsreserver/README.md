## Tutorial Source
https://learn.microsoft.com/en-us/azure/developer/java/spring-framework/getting-started-with-spring-cloud-function-in-azure

# Run locally

## Build and run
```shell
cd ~/petstore/orderitemsreserver
mvn clean package azure-functions:run
```

## Test
```shell
curl -X POST http://localhost:7071/api/reserve-order-items -d "{\"id\":\"uuid\"}"
```
```shell
curl --location 'http://localhost:7071/api/reserve-order-items' \
--header 'Content-Type: application/json' \
--data-raw '{
  "id": "uuid",
  "email": "test@email.com2",
  "products": [
    {
      "id": 1,
      "category": {
        "id": 2,
        "name": "name"
      },
      "name": "name",
      "photoURL": "url",
      "tags": [
        {
          "id": 3,
          "name": "name"
        }
      ],
      "quantity": 1
    }
  ],
  "shipDate": "2023-08-27T22:46:50.936368+03:00",
  "status": "placed",
  "complete": false
}'
```

# Run on Azure

## Deploy
```shell
az login
mvn clean package azure-functions:deploy
```

## Test
```shell
curl -X POST https://petstore-reserve-order-items.azurewebsites.net/api/reserve-order-items -d "{\"id\":\"uuid\"}"
```
```shell
curl --location 'https://petstore-reserve-order-items.azurewebsites.net/api/reserve-order-items' \
--header 'Content-Type: application/json' \
--data-raw '{
  "id": "uuid",
  "email": "test@email.com2",
  "products": [
    {
      "id": 1,
      "category": {
        "id": 2,
        "name": "name"
      },
      "name": "name",
      "photoURL": "url",
      "tags": [
        {
          "id": 3,
          "name": "name"
        }
      ],
      "quantity": 1
    }
  ],
  "shipDate": "2023-08-27T22:46:50.936368+03:00",
  "status": "placed",
  "complete": false
}'
```

## Clean up all resources
```shell
az group delete \
    --name learn-azure-temporal \
    --yes
```


# Useful info
In case of error "Failed to discover main class"
```text
with latest dependencies it works if specify

MAIN_CLASS in local.settings.json
MAIN_CLASS in src/main/azure/local.settings.json
start-class in pom.xml
```
https://github.com/Azure/azure-functions-java-worker/issues/338  
https://github.com/microsoft/azure-maven-plugins/issues/912