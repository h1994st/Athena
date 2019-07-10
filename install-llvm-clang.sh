#!/bin/bash

set -e

VERSION=""
DEBUG="no"
BASE_URL="http://releases.llvm.org"

source log.sh

START_TIME=$(get_now)

function usage() {
    cat <<EOF
Usage: $(basename $0) [options]
OPTIONS:
    -V, --version <version>     Specify which version of LLVM to install.
    -d, --debug                 Install debug version.
    -h, --help                  Display this help information.

Examples:
    $(basename $0) -d -V 8.0.0
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
        -d|--debug)
            DEBUG="yes"
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
    error "Please specify LLVM version"
    usage
    exit 2
fi

BASE_URL="${BASE_URL}/$VERSION"
LLVM_SRC_DIR="llvm-${VERSION}.src"
CLANG_SRC_DIR="cfe-${VERSION}.src"
COMPILER_RT_SRC_DIR="compiler-rt-${VERSION}.src"
LLVM_SRC_TAR="${LLVM_SRC_DIR}.tar.xz"
CLANG_SRC_TAR="${CLANG_SRC_DIR}.tar.xz"
COMPILER_RT_SRC_TAR="${COMPILER_RT_SRC_DIR}.tar.xz"
LLVM_BUILD_DIR="llvm-${VERSION}-build"

DEBUG_TYPE="RelWithDebInfo"

if [ "$DEBUG"x = "yes"x ] ; then
    DEBUG_TYPE="Debug"
fi
LLVM_BUILD_DIR="${LLVM_BUILD_DIR}-${DEBUG_TYPE}"

function download() {
    if [ ! -d $1 ] ; then
        info "Download $1"
        wget "${BASE_URL}/$1"
    else
        info "$1 already exists"
    fi
}

function unzip() {
    # Sanity check
    if [ ! -f $1 ] ; then
        error "File not found: $1"
        exit 2
    fi

    info "Unzip $1"
    tar -xJvf $1
}

function move_to() {
    info "Move \"$1\" to \"$2\""
    mv $1 $2
}

function main() {
    # Download source codes
    info "Start downloading source codes ..."
    download $LLVM_SRC_TAR  # LLVM
    download $CLANG_SRC_TAR  # Clang
    download $COMPILER_RT_SRC_TAR  # compiler-rt

    # Unzip source codes
    info "Start unzipping files ..."
    unzip $LLVM_SRC_TAR
    unzip $CLANG_SRC_TAR
    unzip $COMPILER_RT_SRC_TAR

    # Move subprojects to LLVM main directory
    info "Start integrating source codes ..."
    move_to ${CLANG_SRC_DIR} "${LLVM_SRC_DIR}/tools/clang"
    move_to ${COMPILER_RT_SRC_DIR} "${LLVM_SRC_DIR}/projects/compiler-rt"

    # Create build directory
    info "Create and switch to workspace \"${LLVM_BUILD_DIR}\""
    mkdir $LLVM_BUILD_DIR
    cd $LLVM_BUILD_DIR

    # CMake
    info "Start building ..."
    cmake -DCMAKE_BUILD_TYPE=${DEBUG_TYPE} "../${LLVM_SRC_DIR}"
    make -j6
    sudo make install
    success "Finish building & installing!"

    # Clean up workspace
    info "Clean up the workspace ..."
    cd ..
    rm -rf $LLVM_SRC_DIR $LLVM_BUILD_DIR
    info "Done!"
}

main

