#!/bin/bash

# init
: ${SYSTEM:=`uname -s`}
if [ "$SYSTEM"x = "Linux"x ] ; then
    # Check zsh
    CHECK_ZSH_INSTALLED=$(grep /zsh$ /etc/shells | wc -l)
    if [ ! $CHECK_ZSH_INSTALLED -ge 1 ]; then
        echo 'Install zsh ...'
        sudo apt-get install zsh
    fi
    unset CHECK_ZSH_INSTALLED
fi

if [ ! -n "$ZSH" ]; then
    ZSH=~/.oh-my-zsh
fi

# Check oh-my-zsh
if [ -d "$ZSH" ]; then
    echo 'Update Oh My Zsh ...'
    env ZSH=$ZSH sh $ZSH/tools/upgrade.sh
else
    echo 'Install Oh My Zsh ...'
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
fi

# Configuration file
if [ -f ~/.zshrc ] ; then
    echo 'Configuration file ~/.zshrc exists'

    if ! [[ -L ~/.zshrc || -h ~/.zshrc ]] ; then
        # Not a symbolic link
        # Back-up
        echo 'Back up existing configuration file to ~/.zshrc.bak'
        mv ~/.zshrc ~/.zshrc.bak;
    fi
fi

if [ "$(readlink ~/.zshrc)"x != "$(pwd)/zshrc"x ] || ! [ -f ~/.zshrc ] ; then
    echo 'Create a symbolic link ...'
    ln -s $(pwd)/zshrc ~/.zshrc
    ls -al ~/.zshrc
fi

echo 'Done!'
