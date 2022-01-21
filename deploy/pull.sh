#!/usr/bin/env bash
set -euo pipefail

if test -f /opt/chicago/etc/planorama/tag.env; then
    . /opt/chicago/etc/planorama/tag.env
fi

export PLANORAMA_DOCKER_TAG=${PLANORAMA_DOCKER_TAG:-staging}

eval $(docker run rlister/ecr-login:latest)

/usr/bin/docker-compose -f /opt/chicago/app/planorama/docker-compose.yml pull
