#!/bin/sh

set -e

docker rm -f box &>/dev/null || true
docker run \
    --name box \
    --network demo \
    --cap-add=NET_ADMIN \
    --privileged \
    --volume $(pwd)/config/opensips.cfg:/etc/opensips/opensips.cfg \
    --volume $(pwd)/config/envoy.yaml:/etc/envoy/envoy.yaml \
    --volume $(pwd)/data/keys/cacert.pem:/etc/envoy/certs/server.crt \
    --volume $(pwd)/data/keys/capem.key:/etc/envoy/certs/server.key \
    --ip 172.20.0.20 \
    --rm \
    -ti \
    box
