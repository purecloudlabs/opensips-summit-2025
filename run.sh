#!/bin/sh

set -e

mkdir -p data/docker/

docker rm -f demo-runner &>/dev/null || true
docker build -f docker/demo-runner/Dockerfile --tag demo-runner .
docker run \
   --name demo-runner \
   --volume $(pwd)/data/docker:/var/lib/docker \
   --volume $(pwd):/work \
   --workdir /work \
   --privileged \
   --rm \
   -ti \
   demo-runner
