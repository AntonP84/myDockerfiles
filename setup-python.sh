#!/bin/bash

apt -qq update
apt install -y build-essential wget
apt install -y libbz2-dev libffi-dev libgdbm-dev libgdbm-compat-dev liblzma-dev libncurses5-dev libreadline-dev libsqlite3-dev libssl-dev zlib1g-dev tk-dev uuid-dev
rm -rf /var/lib/apt/lists/*

wget --no-verbose -O python.tar.xz https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz
mkdir -p /usr/src/python
tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz
rm python.tar.xz

cd /usr/src/python
./configure --enable-optimizations --quiet
make -j4 --quiet
make install > /dev/null
ldconfig

find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests \) \) \
			-o \
			\( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
		\) -exec rm -rf '{}' + 
rm -rf /usr/src/python

# make some useful symlinks that are expected to exist
cd /usr/local/bin
ln -s idle3 idle
ln -s pydoc3 pydoc
ln -s python3 python
ln -s pip3 pip
ln -s python3-config python-config

pip install --no-cache-dir -qU pip