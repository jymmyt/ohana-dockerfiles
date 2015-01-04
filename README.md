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

Go to the newly cloned 'ohana-api-dockerfile directory' and run this command.
```
docker build t="imaitland/ohana" . 
```
Just like before that has downloaded the image but we need to set it to run. Furthermore we want it to run *AND* connect to the PostgreSQL container. 

To do this we use the --link option.
```
$ docker run -t -i --link postgresql:db ohana bash
```
What this does is connect the postgresql container as alias 'db' inside the new ohana container.
`Note: This assumes you're already running the database container with the name postgresql.`

Usefully, the 'bash' command will make your container interactive as soon as it is running.
From 'inside' the new container you can connect to the database by running the following commands:
```
$ psql -U "$DB_ENV_USER" \
       -h "$DB_PORT_5432_TCP_ADDR" \
       -p "$DB_PORT_5432_TCP_PORT" \
       template1
```
Alternatively discover the Host port for the postgresql container with:
```
$echo $DB_PORT
$psql -h 172.17.0.250 -U super template1
```

Note: specify the database 'template1' because ... http://stackoverflow.com/questions/17633422/psql-fatal-database-user-does-not-exist

Great, we now have all of the [pre-requisites for Ohana](https://github.com/codeforamerica/ohana-api/blob/master/INSTALL.md) containerized

##Working sketchpad.
On Linux, PostgreSQL authentication can be set to Trust in pg_hba.conf for ease of installation. Create a user that can create new databases, whose name matches the logged-in user account:

$ sudo -u postgres createuser --createdb --no-superuser --no-createrole `whoami`


##Roadmap

Ultimately the Ohana-Api Dockerfile will grab the Ohana Repo and install, essentially 4 lines to cook-up an Ohana instance:
```
docker build -t="ohana/postgresql" /dir/to/postgresql-dockerfile
docker run -d postgresql
docker build -t="ohana/api" /dir/to/ohana-api-dockerfile
docker run -t -i --link postgresql:db ohana

docker exec ohana <some config script>
```
