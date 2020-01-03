#!/bin/bash

apt -qq update

# set the timezone
apt install -y tzdata
ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

# install some tools
apt install -y apt-utils cmake unzip zip nano wget curl git net-tools htop iputils-ping
apt install -y graphviz

# clean up
rm -rf /var/lib/apt/lists/*

# add local non-root user
groupadd -g ${NB_GID} ${NB_USER}
useradd -m -l -u ${NB_UID} -g ${NB_GID} ${NB_USER}
