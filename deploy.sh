#!/bin/bash
set -o pipefail -xe
IMAGE="cconstantine/recall:sha-`git rev-parse --short HEAD`"

cd deployment

TF_VAR_docker_image=$IMAGE terraform apply -auto-approve 