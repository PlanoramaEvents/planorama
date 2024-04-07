#!/usr/bin/bash

if [ $# -eq 0 ]; then
    latest_tag=$(curl -s https://api.github.com/repos/PlanoramaEvents/planorama/releases/latest | jq -r '.tag_name')
    export PLANO_VERSION=$latest_tag
elif [ $# -eq 1 ] && [ "$1" == "staging" ]; then
    staging_tag=$(curl -s https://api.github.com/repos/PlanoramaEvents/planorama/releases | jq -r '.[0].tag_name')
    export PLANO_VERSION=$latest_tag
elif [ $# -eq 1 ]; then
    export PLANO_VERSION=$1
else
    echo "Usage: $0 [staging,VERSION NUMBER]"
    exit 1
fi

echo "Plano version: $PLANO_VERSION"
cd /opt/glasgow2024/app 
/usr/bin/docker compose pull && /usr/bin/docker compose down && /usr/bin/docker compose up -d
