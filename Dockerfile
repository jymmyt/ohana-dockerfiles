FROM debian:wheezy
MAINTAINER imaitland@gmail.com

RUN apt-get update
RUN apt-get -y upgrade 
RUN apt-get install -y apt-utils

# Ensure UTF-8
RUN apt-get -y install locales
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

#Install dependencies

#Install Nokogiri dependencies
RUN apt-get install -y libxml2 libxml2-dev libxslt1-dev

#Install Ruby 2.1.5 dependencies
RUN apt-get install -y wget curl git git-core build-essential \
    libmysqlclient-dev libpq-dev \
    zlib1g-dev libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev

#Install PhantomJS dependencies
RUN apt-get install -y wget libfontconfig1-dev libssl-dev

#Install Postgresql dependencies
RUN apt-get install -y postgresql-client

#Install Ruby 2.1.5 - (https://registry.hub.docker.com/u/ashchan/ruby-2.1.5/dockerfile/)

RUN wget -O ruby-2.1.5.tar.gz http://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.5.tar.gz
RUN tar -xzf ruby-2.1.5.tar.gz
RUN cd ruby-2.1.5/ && ./configure && make && make install

RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem install bundler

#Install NodeJS Setup with Debian, copied from https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager#debian-and-ubuntu-based-linux-distributions
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get -y install nodejs

#Install PhantomJS 
RUN wget -q https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.7-linux-x86_64.tar.bz2
RUN tar xjf phantomjs-1.9.7-linux-x86_64.tar.bz2
RUN install -t /usr/local/bin phantomjs-1.9.7-linux-x86_64/bin/phantomjs
RUN rm -rf phantomjs-1.9.7-linux-x86_64
RUN rm phantomjs-1.9.7-linux-x86_64.tar.bz2

#add database config script (run this once the image has been built and the container is active)
ADD bin/dbconfig.sh /usr/sbin/
RUN chmod 755 /usr/sbin/dbconfig.sh

#get sudo
RUN apt-get update && apt-get -y install sudo

#add a password-less non-root user
RUN adduser --disabled-password --gecos "" ohanauser
RUN chown ohanauser:users /home/ohanauser
#RUN echo "ohanauser   ALL= (ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers
# setup passwordless sudo
RUN echo "ohanauser         ALL = (ALL) NOPASSWD: ALL" > /etc/sudoers.d/ruby
RUN chmod 0440 /etc/sudoers.d/ruby

#get the OHANA code
RUN git clone https://github.com/codeforamerica/ohana-api.git /home/ohanauser/ohana

#create the default settings file for ohana
RUN cp /home/ohanauser/ohana/config/application.example.yml /home/ohanauser/ohana/config/application.yml

#expose ports
EXPOSE 22
EXPOSE 80

#Change to ohanauser to run the ohana install script...
#sudo -u ohanauser -s
