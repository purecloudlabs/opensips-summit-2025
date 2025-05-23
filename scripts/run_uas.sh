#!/bin/sh

set -e

docker rm -f uas &>/dev/null || true
docker run \
    --name uas \
    --network demo \
    --volume $(pwd)/data/keys/cacert.pem:/cacert.pem \
    --volume $(pwd)/data/keys/capem.key:/capem.key \
    --ip 172.20.0.30 \
    --rm \
    -ti \
    sipp \
        -sn uas \
        -t l1 \
        -tls_cert /cacert.pem \
        -tls_key /capem.key \
        -p 5061
