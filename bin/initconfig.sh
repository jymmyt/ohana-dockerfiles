#! /bin/bash

sed -i '/pg_restore/c\pg_restore -c --no-owner -h "$DB_PORT_5432_TCP_ADDR" -p "$DB_PORT_5432_TCP_PORT" -U postgres -d ohana_api_development data/ohana_api_development.dump' /home/ohanauser/ohana/script/restore
 
