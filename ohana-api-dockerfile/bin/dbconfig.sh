#! bin/bash
#edit ~/ohana/config/database.yml so that it points to the postgresql container
#NB - this script needs to be executable i.e. sudo chmod a+x dbconfig.sh

newhost="$echo $DB_PORT_5432_TCP_ADDR"
oldhost="localhost"
sudo sed -i 's/'"$oldhost"'/'"$newhost"'/g' home/ohana/config/database.yml

