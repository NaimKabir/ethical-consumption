#!/bin/bash

set -euo pipefail

arg=$1

# If 'up', set up dev server
if [ "$arg" == "up" ];
then
    cd server; docker-compose --file docker-compose.yml up --detach; cd -

    # restore wiki set-up tables
    # process on how I stored them recorded here: https://github.com/NaimKabir/ethical-consumption/pull/12
    echo "Constructing up Wiki tables..."
    docker cp -L server/data/wiki_set_up.sql database:.
    docker exec database bash -c "psql -U postgres -d default < wiki_set_up.sql"

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
