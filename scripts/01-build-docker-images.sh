#!/usr/bin/env bash

build_docker_pet() {
#   TODO: replace with valid path
  cd ~/petstore/petstorepetservice
  az acr build --registry $CONTAINER_REGISTRY --image $BE_WEB_APP_PET .
}

build_docker_product() {
#   TODO: replace with valid path
  cd ~/petstore/petstoreproductservice
  az acr build --registry $CONTAINER_REGISTRY --image $BE_WEB_APP_PRODUCT .
}

build_docker_order() {
#   TODO: replace with valid path
  cd ~/petstore/petstoreorderservice
  az acr build --registry $CONTAINER_REGISTRY --image $BE_WEB_APP_ORDER .
}

build_docker_main_app() {
#   TODO: replace with valid path
  cd ~/petstore/petstoreapp
  az acr build --registry $CONTAINER_REGISTRY --image $MAIN_WEB_APP:$1 .
}

MAIN_WEB_APP=petstore-app
BE_WEB_APP_PET=petstore-pet-service
BE_WEB_APP_PRODUCT=petstore-product-service
BE_WEB_APP_ORDER=petstore-order-service
CONTAINER_REGISTRY=amazingregistry

build_docker_pet
build_docker_product
build_docker_order
build_docker_main_app v3
