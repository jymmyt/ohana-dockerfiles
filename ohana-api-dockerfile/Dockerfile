# Before you can run Ohana API, you'll need to have the following software packages installed on your computer: 
#	PostgreSQL - Running on a seperate container! Make sure this is running first...
#	Git
#	Ruby 2.1+
#	RVM
#	PhantomJS
#	Node.js

FROM debian:wheezy
MAINTAINER imaitland@gmail.com
ENV DEBIAN_FRONTEND noninteractive # this is optional

#Install Ruby 2.1.5 - (https://registry.hub.docker.com/u/ashchan/ruby-2.1.5/dockerfile/)

RUN locale-gen --no-purge en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install -y wget curl git git-core build-essential \
    libmysqlclient-dev libpq-dev \
    zlib1g-dev libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev

RUN wget -O ruby-2.1.5.tar.gz http://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.5.tar.gz
RUN tar -xzf ruby-2.1.5.tar.gz
RUN cd ruby-2.1.5/ && ./configure && make && make install

RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem install bundler

#Install 'Nokogiri dependencies'
RUN apt-get install -y libxml2 libxml2-dev libxslt1-dev


#Install NodeJS Setup with Debian, copied from https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager#debian-and-ubuntu-based-linux-distributions
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get -y install nodejs


#Install 'PhantomJS dependencies' 
RUN apt-get install -y bzip2 libfontconfig1 vim git wget libfreetype6

#Install PhantomJS (https://registry.hub.docker.com/u/cmfatih/phantomjs/dockerfile/) 

RUN \ 
	mkdir -p /srv/var && \
	wget -q --no-check-certificate -O /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
	tar -xjf /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 -C /tmp && \
	rm -f /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
	mv /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/ /srv/var/phantomjs && \
	ln -s /srv/var/phantomjs/bin/phantomjs /usr/bin/phantomjs && \
	git clone https://github.com/n1k0/casperjs.git /srv/var/casperjs && \
	ln -s /srv/var/casperjs/bin/casperjs /usr/bin/casperjs && \
	apt-get autoremove -y && \
	apt-get clean all

#Install Postgresql client
RUN apt-get install -y postgresql-client

# Get the OHANA app (note we should change directory before downloading the ohana app and give that directory chmod 777)
RUN sudo mkdir ~/ohana
RUN sudo chmod 755 ~/ohana

#get the OHANA code
RUN sudo git clone https://github.com/codeforamerica/ohana-api.git ~/ohana

