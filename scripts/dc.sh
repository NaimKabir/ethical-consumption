#!/bin/bash

set -euo pipefail

arg=$1

# If 'up', set up dev server
if [ "$arg" == "up" ];
then
    cd server; docker-compose --file docker-compose.yml up --detach; cd -
    exit 0
fi

# If 'down', tear down dev server
if [ "$arg" == "down" ];
then
    cd server; docker-compose down --remove-orphans; cd -
    exit 0
fi

echo "ERROR: Input must be 'up' or 'down'"
exit 1
