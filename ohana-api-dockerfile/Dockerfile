# Before you can run Ohana API, you'll need to have the following software packages installed on your computer: 
#	PostgreSQL - Running on a seperate container! Make sure this is running first...
#	Git
#	Ruby 2.1+
#	RV
#	PhantomJS
#	Node.js

#INIT
FROM debian:wheezy
MAINTAINER imaitland@gmail.com
#ENV DEBIAN_FRONTEND noninteractive #Optional
RUN apt-get update 

# Ensure UTF-8
RUN apt-get -y install locales
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

#NodeJS Setup with Debian, copied from https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager#debian-and-ubuntu-based-linux-distributions
RUN apt-get -y install curl
RUN curl -sL https://deb.nodesource.com/setup | bash -
#Install with Debian
RUN apt-get -y install nodejs

# A core development system should typically include build tools like Make and GCC. Make is a utility that automatically builds executable programs and libraries from source code. The GNU Compiler Collection (GCC) is a compiler system produced by the GNU Project supporting various programming languages.

RUN apt-get -y install build-essential


# Commands from https://github.com/ubermuda/docker-phantomjs/blob/master/Dockerfile
RUN apt-get -y update
RUN apt-get -y install curl bzip2 libfreetype6 libfontconfig
RUN curl -sL https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-x86_64.tar.bz2 | tar xj
RUN ln -s phantomjs-*-linux-x86_64 /phantomjs

VOLUME ["/srv"]

##NB From: https://github.com/codeforamerica/howto/blob/master/PostgreSQL.md
#To use PostgreSQL with any Ruby app that uses the pg gem, you will also need to install libpq-dev:
#I don't know if I need this here or in the Postgresql database container so I've put it in both.
RUN apt-get -y install libpq-dev

#Ruby environment from https://registry.hub.docker.com/u/cthulhu666/docker-rbenv/dockerfile/raw

RUN apt-get update && \
    apt-get install -y sudo build-essential libssl-dev libreadline6-dev curl git-core && \
    apt-get clean

ADD bin/install-rbenv.sh /usr/sbin/
ADD bin/init.sh /usr/sbin/

RUN chmod 755 /usr/sbin/install-rbenv.sh && \
    chmod 755 /usr/sbin/init.sh

RUN useradd -m -d /home/ruby -p ruby ruby && adduser ruby sudo && chsh -s /bin/bash ruby

RUN init.sh
RUN install-rbenv.sh

USER ruby
ENV HOME /home/ruby
ENV PATH /home/ruby/.rbenv/shims:/home/ruby/.rbenv/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN sudo mkdir /app && sudo chown ruby:ruby /app # placeholder for application code

