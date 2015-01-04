#Ohana meets Docker

##Introduction
Much like the [Ohana Vagrant Virtual Machine](https://github.com/codeforamerica/ohana-api-dev-box) "This project automates the setup of a development environment for working on Ohana API" That project uses Vagrant and this uses Docker...

##What you'll need
Docker.

##Inside the box
[The code-for-america 'Ohana-Api'](https://github.com/codeforamerica/ohana-api/blob/master/INSTALL.md) relies on a number of software tools before it can be installed. It also requires a PostgreSQL database to be up and running.

Here you will find Dockerfiles to meet these pre-requisites.

##PostgreSQL Dockerfile
Pull and run the official Postgresql Docker image:
```
docker run --name db -d postgres
```
```
docker exec -it db /bin/bash
```
```
psql -U postgres
```
```
CREATE USER ohanauser WITH CREATEDB SUPERUSER CREATEROLE;
CREATE DATABASE ohanauser OWNER ohanauser;
```
(ctrl+d) to exit pgres
```
echo "listen_addresses='*'" >> /var/lib/postgresql/data/postgresql.conf
echo "host all all 0.0.0.0/0 trust" >> /var/lib/postgresql/data/pg_hba.conf
```
(ctrl+d) to exit container
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
```
docker run -t -i -p 80:80 -p 2222:22 --link db:db --name=ohana-app imaitland/ohana bash
```
run the db config script
```
dbconfig.sh
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
```
test the pgres container
```
psql -h "$DB_PORT_5432_TCP_ADDR" -p "$DB_PORT_5432_TCP_PORT" -U postgres
```
run the dbconfig script
```
dbconfig.sh
```
