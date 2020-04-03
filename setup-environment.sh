#!/bin/bash

apt -qq update

# set the timezone
apt install -yqq tzdata
ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

# install some tools
apt install -yqq apt-utils cmake unzip zip nano wget curl git net-tools htop iputils-ping
apt install -yqq graphviz


# install Python3.6 for ubuntu18.04
apt install -yqq python3 python3-dev python3-pip

## make some useful symlinks that are expected to exist
cd /usr/bin
ln -s python3 python
ln -s pip3 pip

pip install --no-cache-dir -qU pip setuptools


# clean up
rm -rf /var/lib/apt/lists/*

# add local non-root user
groupadd -g ${NB_GID} ${NB_USER}
useradd -m -l -u ${NB_UID} -g ${NB_GID} ${NB_USER}
