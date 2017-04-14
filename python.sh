#!/bin/bash

# init
: ${SYSTEM:=`uname -s`}
if [ "$SYSTEM"x = "Linux"x ] ; then
    sudo add-apt-repository ppa:fkrull/deadsnakes-python2.7
    sudo apt-get update
    sudo apt-get install python2.7
fi
