#!/bin/bash
GO_TARGET_VERSION="go1.7.5"
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
        # Setup where to find go1.4
        if [ ! -d $HOME/go1.4 ]; then
            echo "Cloning go v1.4"
            git clone https://github.com/golang/go go1.4
        fi

        # Compile go1.4 if necessary
        if [ ! -f $HOME/go1.4/bin/go ]; then
            echo "Checking out and compiling go 1.4.3"
            cd $HOME/go1.4
            git checkout go1.4.3
            cd src
            ./all.bash
            cd
        fi

        # Setup where to find $GO_TARGET_VERSION
        if [ ! -d $HOME/go ]; then
            echo "Cloning go to $HOME/go"
            git clone https://github.com/golang/go
        fi

        cd $HOME/go
        git fetch origin
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
        cd
        export GOPATH=$HOME
    fi
fi
T=$(go version 2> /dev/null)
if [ "$T" != "" ]; then
    echo "$T"
fi

GOPHERJS=$(which gopherjs)
if [ "$GOPHERJS" = "" ]; then
    read -p "Install GopherJS? Y/N " Y_OR_N
    if [ "$Y_OR_N" = "Y" ] || [ "$Y_OR_N" = "y" ]; then
        go get -u github.com/gopherjs/gopherjs/...
    fi
fi
