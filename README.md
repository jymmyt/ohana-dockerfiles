#Ohana meets Docker

##Introduction
Much like the [Ohana Vagrant Virtual Machine](https://github.com/codeforamerica/ohana-api-dev-box) "This project automates the setup of a development environment for working on Ohana API" That project uses Vagrant and this uses Docker...

##What you'll need
Docker (v.1.3 at time of writing)

##Inside the box
[The code-for-america 'Ohana-Api'](https://github.com/codeforamerica/ohana-api/blob/master/INSTALL.md) relies on a number of software tools before it can be installed. It also requires a PostgreSQL database to be up and running.

Here you will find Dockerfiles to meet these pre-requisites. The PostgreSQL database runs on a container that is linked to another container running the Ohana-api app. 

##PostgreSQL Dockerfile
Pull and run the official Postgresql Docker image:
```
docker run --name db -d postgres
```
Enter the running container
```
docker exec -it db /bin/bash
```
Create the ohana_api_development database
```
psql -U postgres
```
```
CREATE DATABASE ohana_api_development;
```
(ctrl+d) to exit pgres


Set the pgres database to listen on all addresses and allow password-less access
```
echo "listen_addresses='*'" >> /var/lib/postgresql/data/postgresql.conf
echo "host all all 0.0.0.0/0 trust" >> /var/lib/postgresql/data/pg_hba.conf
```
(ctrl+d) to exit container


Restart the container to propogate changes to config
```
docker stop db
docker start db
```

##OHANA basic requirements Dockerfile
```
git clone https://github.com/gl2748/ohana-dockerfiles.git
```
```
docker build t="imaitland/ohana" . 
```
Run the ohana image, open the ports 80 and 22 to the host machine (i.e. the wider world) link it to the pgres database container, name it ohana-app  
```
docker run -t -i -p 80:80 -p 2222:22 --link db:db --name=ohana-app imaitland/ohana
```
Enter the running container
```
docker exec -i -t ohana-app bash 
```
run the config scripts
```
dbconfig.sh
initconfig.sh
```
change user
```
sudo -u ohanauser -s
```
rogue permission error
```
sudo chmod -R 1777 /home
```
run the ohana setup script
```
/home/ohanauser/ohana/script/bootstrap
```
start the rails app
```
rails s -p 80

```
To be confirmed.
Leave the container (without quitting running apps)
Dump the Create db in pgres setup.
exec into ohana
login as non-root

