#!/bin/bash

# Need: git vim

# init
: ${SYSTEM:=`uname -s`}
if [ "$SYSTEM"x = "Linux"x ] ; then
    # Check vim
    if ! command -v vim > /dev/null 2>&1 ; then
        echo 'Install vim...'
        sudo apt-get install vim
    fi
fi

# Sync all vim configuration files
echo 'Sync configuration files...'
# TODO: Check whether this is the first time to download configuration files from Github
sh -c "$(curl -fsSL https://raw.githubusercontent.com/h1994st/interesting-scripts/master/sync-vim-conf.sh)"
