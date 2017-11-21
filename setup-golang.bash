#!/bin/bash

function MacOSX_Ugly_Build_Problem() {
    if [ ! -f /usr/local/go/bin/go ]; then
        echo "If you are running Mac OS X Sierra compiling will be VERY problematic"
        echo "You need to bootstrap from a compiled Binary release like go1.8."
        echo "See https://golang.org/doc/install?download=go1.8.darwin-amd64.pkg"
        echo ""
        read -p "Do you want to continue? Y/N " Y_OR_N
        if [ "$Y_OR_N" != "Y" ] && [ "$Y_OR_N" != "y" ]; then
            exit 0
        fi
    fi
    export GOROOT_BOOTSTRAP=/usr/local/go
}

START=$(pwd)
GO_TARGET_VERSION="go1.9.2"
CC=$(which cc)
if [ "$CC" = "" ]; then
    export CGO_ENABLED=0
else
    export CGO_ENABLED=1
fi

GO_VERSION=""
GOLOCATION=$(which go)
if [ -f $HOME/go/bin/go ] || [ "$GOLOCATION" != "" ]; then
    export GOPATH=$HOME
    GO_VERSION=$(go version | grep "$GO_TARGET_VERSION")
fi
if [ "$GO_VERSION" = "" ]; then
    read -p "Clone, compile and (re)install Go now? Y/N " INSTALL_GO
    if [ "$INSTALL_GO" = "Y" ] || [ "$INSTALL_GO" = "y" ]; then
        if [ "${HOME:0:6}" = "/Users" ] && [ "${TERM_PROGRAM:0:5}" = "Apple" ]; then
            # Handle Mac Ugly bootstrap problem
            MacOSX_Ugly_Build_Problem
        else
            # Setup where to find go1.4
            if [ ! -d "$HOME/go1.4" ]; then
                echo "Cloning go v1.4"
                git clone https://github.com/golang/go $HOME/go1.4
            fi

            # Compile go1.4 if necessary
            if [ ! -f "$HOME/go1.4/bin/go" ]; then
                echo "Checking out and compiling go 1.4.3"
                cd $HOME/go1.4
                git checkout master
                git fetch origin
                git pull origin master
                git checkout go1.4.3
                cd src
                ./all.bash
                cd $HOME
            else
                echo "Using $($HOME/go1.4/bin/go version) to bootstrap"
            fi
        fi

        # Setup where to find $GO_TARGET_VERSION
        if [ ! -d $HOME/go ]; then
            echo "Cloning go to $HOME/go"
            git clone https://github.com/golang/go $HOME/go
        fi

        cd $HOME/go
        git checkout master
        git fetch origin
        git pull origin master
        GO_VERSION=$(git branch | grep "$GO_TARGET_VERSION")
        if [ "$GO_VERSION" = "" ]; then
            git checkout $GO_TARGET_VERSION
        fi
        if [ -f bin/go ]; then
            GO_VERSION=$(bin/go version | grep "$GO_TARGET_VERSION")
        fi
        # Compile $GO_TARGET_VERSION
        if [ "$GO_VERSION" = "" ]; then
            echo "Checking out and compiling $GO_TARGET_VERSION"
            export CGO_ENABLED=0
            git checkout $GO_TARGET_VERSION
            cd src
            ./all.bash
        fi
        cd $HOME
        export GOPATH=$HOME
    fi
fi
echo "Checking go version installed"
T=$(go version 2> /dev/null)
if [ "$T" != "" ]; then
    echo "$T"
else
    echo "Failed to find Go"
    exit 1
fi

#GOPHERJS=$(which gopherjs)
#if [ "$GOPHERJS" = "" ]; then
#    read -p "Install GopherJS? Y/N " Y_OR_N
#    if [ "$Y_OR_N" = "Y" ] || [ "$Y_OR_N" = "y" ]; then
#        go get -u github.com/gopherjs/gopherjs/...
#    fi
#fi
