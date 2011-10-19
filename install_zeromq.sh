#!/bin/bash

ZMQ_VERSION="2.1.10" 
ARCHIVE="zeromq-${ZMQ_VERSION}.tar.gz"

if [ -z "${VIRTUAL_ENV}" ]; then
    echo "Please activate a virtualenv first";
    exit
fi

pushd /tmp/
wget http://download.zeromq.org/${ARCHIVE}
tar xzf ${ARCHIVE}
pushd zeromq-${ZMQ_VERSION}
# make / make install w/ prefix
make clean
./configure --prefix=${VIRTUAL_ENV} 
make
make install
popd
popd
