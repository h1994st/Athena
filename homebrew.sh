#!/bin/bash

# Homebrew, macOS only

# init
: ${SYSTEM:=`uname -s`}
if [ "$SYSTEM"x != "Darwin"x ] ; then
    exit 1;
fi

# Check whether Homebrew is installed
if command -v brew > /dev/null 2>&1 ; then
    echo 'Update Homebrew...'
    brew update
else
    echo 'Install Homebrew...'
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Formulas
formulas=(git git-flow wget ctags go pandoc cloc class-dump carthage)
echo 'Formulas: '${formulas[@]}
for formula in ${formulas[@]}
do
    if brew ls --versions myformula > /dev/null 2>&1 ; then
        brew upgrade $formula
    else
        brew install $formula
    fi
done

# TODO: Homebrew Cask

echo 'Done!'
