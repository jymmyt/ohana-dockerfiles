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

#Housecleaning
RUN apt-get update
RUN apt-get -y install apt-utils
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

# Ruby is a dynamic, reflective, object-oriented, general-purpose programming language. It’s typically used for web development with Ruby On Rails, Sinatra, or Jekyll.
# Ruby Version Manager (RVM) is a command-line tool which allows you to easily install, manage, and work with multiple Ruby environments, from interpreters to sets of gems. The Ruby language is under active development, and the version that ships with your operating system may be older than the versions expected by current frameworks such as Rails. RVM helps bring your Ruby up to date.

#This line throws an error because nvm prompts to add user
#RUN curl -L https://get.rvm.io | bash -s stable --autolibs=enabled --ruby

#is RVM necessary for docker / Ruby? 

#Note: RVM warns against installing as root, so we will create a user and install through them... via https://github.com/vallard/docker/blob/master/rails/Dockerfile

# NVM has a gpg, designed so that you have some assurance that the rvm code hasn't been tampered with, this means you need to add their key before you go ahead and install...CF. https://github.com/wayneeseguin/rvm/issues/3110
#RUN apt-get -y install gpg

RUN \
	gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3 && \
	curl -L https://get.rvm.io | bash -s stable --autolibs=enabled --ruby && \
	#/bin/bash -l -c "curl -L get.rvm.io | bash -s stable --rails" && \
	/bin/bash -l -c "rvm install 2.1" && \
	/bin/bash -l -c "echo 'gem: --no-ri --no-rdoc' > ~/.gemrc" && \
	/bin/bash -l -c "gem install bundler --no-ri --no-rdoc" && \

#ENV USER gl2748
#RUN /bin/bash -l -c "source /home/$USER/.rvm/scripts/rvm"

#Install PhantomJS copied from http://phantomjs.org/build.html
RUN apt-get -y install chrpath git-core libssl-dev libfontconfig1-dev libxft-dev
RUN git clone git://github.com/ariya/phantomjs.git
RUN cd phantomjs
RUN git checkout 1.9
RUN ./build.sh

##NB From: https://github.com/codeforamerica/howto/blob/master/PostgreSQL.md
#To use PostgreSQL with any Ruby app that uses the pg gem, you will also need to install libpq-dev:
#I don't know if I need this here or in the Postgresql database container so I've put it in both.
RUN apt-get -y install libpq-dev
