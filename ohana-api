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
RUN \
  apt-get update && \
  apt-get upgrade -y 

#NodeJS Setup with Debian, copied from https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager#debian-and-ubuntu-based-linux-distributions
apt-get install curl
curl -sL https://deb.nodesource.com/setup | bash -
#Install with Debian
apt-get install -y nodejs

# A core development system should typically include build tools like Make and GCC. Make is a utility that automatically builds executable programs and libraries from source code. The GNU Compiler Collection (GCC) is a compiler system produced by the GNU Project supporting various programming languages.

apt-get install -y build-essential

# Ruby is a dynamic, reflective, object-oriented, general-purpose programming language. It’s typically used for web development with Ruby On Rails, Sinatra, or Jekyll.
# Ruby Version Manager (RVM) is a command-line tool which allows you to easily install, manage, and work with multiple Ruby environments, from interpreters to sets of gems. The Ruby language is under active development, and the version that ships with your operating system may be older than the versions expected by current frameworks such as Rails. RVM helps bring your Ruby up to date.

curl -L https://get.rvm.io | bash -s stable --autolibs=enabled --ruby

#make environment aware of RVM
source ~/.rvm/scripts/rvm

#Install PhantomJS copied from http://phantomjs.org/build.html
apt-get install chrpath git-core libssl-dev libfontconfig1-dev libxft-dev
git clone git://github.com/ariya/phantomjs.git
cd phantomjs
git checkout 1.9
./build.sh

##NB From: https://github.com/codeforamerica/howto/blob/master/PostgreSQL.md
#To use PostgreSQL with any Ruby app that uses the pg gem, you will also need to install libpq-dev:
#I don't know if I need this here or in the Postgresql database container so I've put it in both.
$ apt-get install libpq-dev


#Housecleaning
apt-get autoremove -y
apt-get clean all



