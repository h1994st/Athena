#!/bin/bash

set -e

# https://github.com/Kitware/CMake/releases/download/v3.14.5/cmake-3.14.5.tar.gz
VERSION=""
BASE_URL="https://github.com/Kitware/CMake/releases/download"

source log.sh

START_TIME=$(get_now)

function usage() {
    cat <<EOF
Usage: $(basename $0) [options]
OPTIONS:
    -V, --version <version>     Specify which version of LLVM to install.
    -h, --help                  Display this help information.

Examples:
    $(basename $0) -V 3.14.5
EOF
exit 0
}

while [ $# -gt 0 ]
do
    case "$1" in
        -V|--version)
            shift
            VERSION=$1
            ;;
        -h|--help)
            usage
            ;;
        *)
            error "Unknown option: $1"
            usage
            exit 2
            ;;
    esac
    shift
done

if [ "$VERSION"x = ""x ] ; then
    error "Please specify CMake version"
    usage
    exit 2
fi

BASE_URL="${BASE_URL}/v${VERSION}"
SRC_DIR="cmake-${VERSION}"
SRC_TAR="${SRC_DIR}.tar.gz"

function download() {
    info "Download $1"
    wget "${BASE_URL}/$1"
}

function unzip() {
    # Sanity check
    if [ ! -f $1 ] ; then
        error "File not found: $1"
        exit 2
    fi

    info "Unzip $1"
    tar -xzvf $1
}

function main() {
    # Download source codes
    info "Start downloading source codes ..."
    download $SRC_TAR  # LLVM

    # Unzip source codes
    info "Start unzipping files ..."
    unzip $SRC_TAR

    # Build
    info "Start building ..."
    cd $SRC_DIR
    ./bootstrap && make -j6 && sudo make install
    success "Finish building & installing!"

    # Clean up workspace
    info "Clean up the workspace ..."
    cd ..
    rm -rf $SRC_DIR $SRC_TAR
    info "Done!"
}

main

