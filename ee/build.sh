#!/bin/bash

VERSION=$1
IMAGE="quay.io/zachp/servicenow_network"

ansible-builder build -t $IMAGE:$VERSION -v 3
podman tag $IMAGE:$VERSION $IMAGE:latest
podman push $IMAGE:$VERSION
podman push $IMAGE:latest
