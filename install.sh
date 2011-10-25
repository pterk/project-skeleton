#!/bin/bash

if [ -z "${VIRTUAL_ENV}" ]; then
    echo "Please activate a virtualenv first";
    exit
fi

if [ ! -f requirements.txt ]; then
    echo "Please run this script in it's own directory"
    exit
fi

./install_zeromq.sh
pip install -r requirements.txt
pip install -r requirements-ztask.txt --install-option="--zmq=${VIRTUAL_ENV}"
