# Before you can run Ohana API, you'll need to have the following software packages installed on your computer: 
#	PostgreSQL - Running on a seperate container! Make sure this is running first...
#	Git
#	Ruby 2.1+
#	RVM
#	PhantomJS
#	Node.js

FROM debian:wheezy
MAINTAINER imaitland@gmail.com

#Install Ruby 2.1.5 - (https://registry.hub.docker.com/u/ashchan/ruby-2.1.5/dockerfile/)

RUN apt-get update
RUN apt-get upgrade -y

# Ensure UTF-8
RUN apt-get -y install locales
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8


RUN apt-get install -y apt-utils wget curl git git-core build-essential \
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

#Install PhantomJS 

RUN apt-get install -y wget libfontconfig1-dev libssl-dev
RUN wget -q https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-x86_64.tar.bz2
RUN tar xjf phantomjs-1.9.7-linux-x86_64.tar.bz2
RUN install -t /usr/local/bin phantomjs-1.9.7-linux-x86_64/bin/phantomjs
RUN rm -rf phantomjs-1.9.7-linux-x86_64
RUN rm phantomjs-1.9.7-linux-x86_64.tar.bz2

#RUN curl -sSL "https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2" \
#&& tar -xjf "phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2" -C /usr/local --strip-components=1 \
#&& rm "phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2" 


#Install Postgresql client
RUN apt-get install -y postgresql-client

#create a user 
RUN adduser --disabled-password --gecos 'OHANA repository dedicated user' --home /home vagrant 

#get the OHANA code
RUN git clone https://github.com/codeforamerica/ohana-api.git /home/ohana1

#add database config script (run this once the image has been built and the container is active)
ADD bin/dbconfig.sh /usr/sbin/
RUN chmod 755 /usr/sbin/dbconfig.sh
