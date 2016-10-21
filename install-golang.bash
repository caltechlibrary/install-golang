#!/bin/bash

BOOTSTRAP=go1.4.3
TARGET=go1.7.3

function setupGolang {
    cd
    mkdir -p bin
    ORIGINAL_PATH="$PATH"
    mkdir -p src
    if [ -f $HOME/go1.4/bin/go ]; then
        echo "Using existing $HOME/go1.4"
        export GOROOT_BOOTSTRAP=$HOME/go1.4
    else
        # Build a bootstrap version of Go
	if [ ! -d $HOME/go1.4 ]; then
            git clone git@github.com:golang/go.git go1.4
        fi
        cd ${BOOTSTRAP:0:5}
        export GOBIN=$HOME/${BOOTSTRAP:0:5}/bin
        git checkout $BOOTSTRAP
        cd src
        ./all.bash
    fi
    # Now build the current version of Go
    cd
    if [ ! -d $HOME/go ]; then
        git clone git@github.com:golang/go.git go
    fi
    cd go/src
    git fetch origin
    git checkout $TARGET
    export GOBIN=$HOME/go/bin
    ./all.bash
    # Update our local environment
    cd
    unset GOBIN
    # Add a configuration examples to the .bashrc file
    echo 'You problably want to add the following to your .bashrc or .profile'
    echo ''
    echo '# Golang Setup '$(date)
    echo 'export PATH=$PATH:$HOME/bin:$HOME/go/bin'
    echo 'export GOPATH=$HOME'
    echo
}

function setupGoTools {
    echo "Installing gopherjs"
    go get -u github.com/gopherjs/gopherjs/...
}

cat <<EOF

    This script will check to see if go is installed. If go is missing
    then this script will attempt to download go from the golang Github
    repository, compile version ${BOOTSTRAP:2} and then use $BOOTSTRAP to compile 
    version ${TARGET:2} of go. These will install to your home 
    directory.

    Sometimes it is easier to install Go from precompiled binaries at 
    golang.org or using your systems' package manager.

EOF

GO_CMD=$(which go)
GO_VERSION_CHECK=$(go version | grep -E "$TARGET")
if [ "$GO_CMD" = "" ] || [ "$GO_VERSION_CHECK" = "" ]; then
    setupGolang
    setupGoTools
else
    echo "Go installed at $GO_CMD"
    echo "Version is "$(go version)
    echo "Gospace needs version 1.4.3 or better to recompile."
fi
