#!/bin/bash

echo Generating scripts
python3 generate_scripts.py
echo Removing old containers
docker rm -f kdb-example-postgres
echo Creating postgres container
docker run \
    --detach \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=example \
    -e POSTGRES_DB=dvdrental \
    -v $(pwd)/:/data \
    --name kdb-example-postgres \
    postgres:10
echo Waiting for it to boot properly
sleep 15
echo Importing sample data
docker exec kdb-example-postgres \
    pg_restore -U postgres -d dvdrental /data/dvdrental.tar
echo Creating csv storage
docker exec kdb-example-postgres mkdir /data/csv
docker exec kdb-example-postgres chown -R postgres:postgres /data/csv
echo Executing dump script
docker exec kdb-example-postgres /bin/bash -c "psql -U postgres -d dvdrental < /data/init.sql"
echo Shutting down postgres container
docker rm -f kdb-example-postgres

echo Building Kx image
docker build -t kdb .
echo Creating Kx container
docker run --rm -it -v $(pwd)/:/data kdb q /data/init.q -p 5001
