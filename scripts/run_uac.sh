#!/bin/sh

set -e

docker rm -f uac &>/dev/null || true
docker run \
    --name uac \
    --network demo \
    --volume $(pwd)/data/keys/cacert.pem:/cacert.pem \
    --volume $(pwd)/data/keys/capem.key:/capem.key \
    --ip 172.20.0.10 \
    --rm \
    -ti \
    sipp \
        -sn uac \
        -t l1 \
        -tls_cert /cacert.pem \
        -tls_key /capem.key \
        -p 5061 \
        -r 1 \
        -d 1000 \
        box:5061
