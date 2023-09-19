#!/usr/bin/env bash

source 00-variables.sh

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

build_docker_pet
build_docker_product
build_docker_order
build_docker_main_app v3
