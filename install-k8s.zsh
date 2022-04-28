#!/bin/bash

set -e

# deploy k3d cluster with extra memory (8G) for Istio install
k3d cluster create local-cluster --servers 1 --agents 1 --api-port 6443 --k3s-arg "--disable=traefik@server:0" --port 8080:80@loadbalancer --port 8081:443@loadbalancer --agents-memory=8G --registry-create local-registry --volume "$PWD"/backup:/tmp/backup
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=$ISTIO_VERSION sh -
