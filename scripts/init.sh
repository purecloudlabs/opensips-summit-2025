#!/bin/sh

set -ex

mkdir -p data/keys/
if [ ! -e "data/keys/capem.key" ] || [ ! -e "data/keys/cacert.pem" ]; then
    openssl req \
        -x509 \
        -newkey rsa:4096 \
        -keyout data/keys/capem.key \
        -out data/keys/cacert.pem \
        -days 365 \
        -nodes \
        -subj "/CN=demo"
fi

docker network rm demo || true
docker network create --subnet=172.20.0.0/16 demo || true

docker build -f docker/box/Dockerfile --tag box .
docker build -f docker/sipp/Dockerfile --tag sipp .
