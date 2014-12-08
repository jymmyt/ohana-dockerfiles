##Ohana meets Docker
[The code-for-america 'Ohana-Api'](https://github.com/codeforamerica/ohana-api/blob/master/INSTALL.md) relies on a number of software tools before it can be installed. It also requires a PostgreSQL database to be up and running.

Here you will find Dockerfiles to meet these pre-requisites so that you can get started with Ohana. 

##PostgreSQL Dockerfile

[Clone the Painted Fox postgres Dockerfile and associated scripts repo to a convenient location.](https://github.com/Painted-Fox/docker-postgresql) Then run the following command from inside the directory where the newly downloaded Dockerfile is located.

```
$ docker build -t="paintedfox/postgresql" .
```
You now  have a postgreSQL image, check it out with the following command:

`docker images`

But nothing listed there is 'awake'. To wake up your dormant image you need to run it. 
```
$ mkdir -p /tmp/postgresql
$ docker run -d --name="postgresql" \
             -p 127.0.0.1:5432:5432 \
             -v /tmp/postgresql:/data \
             -e USER="super" \
             -e DB="database_name" \
             -e PASS="$(pwgen -s -1 16)" \
             paintedfox/postgresql
```

You now have a postgreSQL container and it's silently whirrring in the background, have a look:

`docker ps`

To interact with your new postgreSQL container from your host environment you can run 

`sudo apt-get install postgresql-client`
`psql -h 127.0.0.1 -U super template1`

Looks like it's prompting you for a password ... oops, the postgreSQL dockerfile must have made one with the `-e PASS="$(pwgen -s -1 16)"` command. To find out what the password is run:
`$ docker logs postgresql`
The password is everything following "POSTGRES_PASS=", with that in mind let's try `psql -h 127.0.0.1 -U super template1` again. Enter the password when prompted. 

Ok, so that's all good, we have the postgreSQL requirement for OHANA in place. 

##OHANA basic requirements Dockerfile

# To view the login in run docker logs <container_name> like so:

$ docker logs postgresql

$ psql -h 127.0.0.1 -U super template1
Then enter the password from the docker logs command when prompted.

##Link the Ohana base-image

$ docker run -t -i --link postgresql:db ubuntu bash

This assumes you're already running the database container with the name postgresql. The --link postgresql:db will give the linked container the alias db inside of the new container.


From the new container you can connect to the database by running the following commands:

$ apt-get install -y postgresql-client
$ psql -U "$DB_ENV_USER" \
       -h "$DB_PORT_5432_TCP_ADDR" \
       -p "$DB_PORT_5432_TCP_PORT"
       -d "template1"
NB: specify the database 'template1' because ... http://stackoverflow.com/questions/17633422/psql-fatal-database-user-does-not-exist

