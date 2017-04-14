#!/bin/bash

# init
echo "Operating System: "${SYSTEM:=`uname -s`}
export SYSTEM

# cleanup
function finish {
  echo 'Exit!'
}
trap finish EXIT

# Command line tools for mac
# sudo xcode-select --install

# oh-my-zsh
printf "[Oh-my-zsh]"
./oh-my-zsh.sh
printf "\n"

# Homebrew
printf "[Homebrew]"
./homebrew.sh
printf "\n"

# Vim
printf "[Vim]"
./vim.sh
printf "\n"

# Python
printf "[Python 2.7.*]"
./python.sh
printf "\n"

# TODO: NVM
# ./nvm.sh

# TODO: RVM
# ./rvm.sh

# TODO: Cocoapods
# ./cocoapods.sh

echo 'Done!'
