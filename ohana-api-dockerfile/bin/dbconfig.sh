#! bin/bash
#edit ~/ohana/config/database.yml so that it points to the postgresql container
#NB - this script needs to be executable i.e. sudo chmod a+x dbconfig.sh

newhost="$echo $DB_PORT_5432_TCP_ADDR"
oldhost="localhost"
sed -i 's/'"$oldhost"'/'"$newhost"'/g' home/ohana1/config/database.yml

newport="$echo $DB_PORT_5432_TCP_PORT"
oldport="5432"
sed -i 's/'"$oldport"'/'"$newport"'/g' home/ohana1/config/database.yml
