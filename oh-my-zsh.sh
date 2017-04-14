#!/bin/bash

# init
: ${SYSTEM:=`uname -s`}
if [ "$SYSTEM"x = "Linux"x ] ; then
    # Check zsh
    CHECK_ZSH_INSTALLED=$(grep /zsh$ /etc/shells | wc -l)
    if [ ! $CHECK_ZSH_INSTALLED -ge 1 ]; then
        echo 'Install zsh...'
        sudo apt-get install zsh
    fi
    unset CHECK_ZSH_INSTALLED
fi

# Check oh-my-zsh
if [ -d "$ZSH" ]; then
    echo 'Update Oh My Zsh...'
    upgrade_oh_my_zsh
else
    echo 'Install Oh My Zsh...'
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

    # Configuration file
    # Back-up
    if [ -f $HOME/.zshrc ] ; then
        mv $HOME/.zshrc $HOME/.zshrc.bak;
    fi
    ln -s $(pwd)/zshrc $HOME/.zshrc
fi

echo 'Done!'
