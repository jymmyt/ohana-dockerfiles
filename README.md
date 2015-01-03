#Ohana meets Docker

##Introduction
Much like the [Ohana Vagrant Virtual Machine](https://github.com/codeforamerica/ohana-api-dev-box) "This project automates the setup of a development environment for working on Ohana API" That project uses Vagrant and this uses Docker...

##What you'll need
Docker.

##Inside the box
[The code-for-america 'Ohana-Api'](https://github.com/codeforamerica/ohana-api/blob/master/INSTALL.md) relies on a number of software tools before it can be installed. It also requires a PostgreSQL database to be up and running.

Here you will find Dockerfiles to meet these pre-requisites.

##PostgreSQL Dockerfile
[Clone this repository to a convenient location on the host](https://github.com/gl2748/ohana-dockerfiles).

Credit: The Postgres Dockerfile comes from [Painted Fox's docker-postgresql repo] (https://github.com/Painted-Fox/docker-postgresql).

Then change into the newly cloned 'postgresql-dockerfile directory' and run this command.

```
$ docker build -t="paintedfox/postgresql" .
```
Alternatively you can build paintedfox's postgresql docker image directly:
```
$ docker pull paintedfox/postgresql
```

You now  have a postgreSQL image, check it out with the following command:

`docker images`

But nothing listed there is 'awake'. To wake up your dormant 'image' and turn it into a 'container' you need to run it. 
```
$ mkdir -p /tmp/postgresql
$ docker run -d --name="postgresql" \
             -p 127.0.0.1:5432:5432 \
             -v /tmp/postgresql:/data \
             -e USER="super" \
             -e DB="database_name" \
             -e PASS="$(pwgen -s -1 16)" \
             paintedfox/postgresql
ALT

$ docker run -d --name="postgresql" \
             -p 127.0.0.1:5432:5432 \
             -v /tmp/postgresql:/data \
             -e USER="super" \
             -e DB="database_name" \
             paintedfox/postgresql



```

You now have a postgreSQL container and it's silently whirrring in the background (-d stands for Daemon), have a look:

`docker ps`

To interact with your new postgreSQL container from your host environment you can run 
```
sudo apt-get install postgresql-client
psql -h 127.0.0.1 -U super template1
```

Looks like it's prompting you for a password ... oops, we  must have made one with the `-e PASS="$(pwgen -s -1 16)"` command. To find out what the password is run:

`$ docker logs postgresql`

The password is everything following "POSTGRES_PASS=", with that in mind try `psql -h 127.0.0.1 -U super template1` again. 

Enter the password when prompted. 

Ok, so that's all good, we have the postgreSQL requirement for Ohana in place. Leave the running container and get back to your host environment. Make sure it's still running with `docker ps`.

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
