#!/bin/bash
#
APT=(which apt)
if [ "$APT" = "" ]; then
  echo "This setup assumed you're install Golang from an Ubuntu Bash shell (e.g. Linux or Windows 10)"
  exit 1
fi
sudo apt update
sudo apt upgrade
sudo apt install build-essential clang git-core zip unzip
cd
git clone https://github.com/golang/go go1.4
cd go1.4/src
git checkout go1.4.3
./all.bash
export GOBIN=$HOME
cd
git clone https://github.com/golang/go go
cd go/src
git checkout go1.7
./all.bash
cd
echo "Checking if go is in the path"
echo 'export GOPATH=$HOME' >> .bashrc
echo 'export PATH=$HOME/bin:$HOME/go/bin:$PATH' >> .bashrc
export PATH=$HOME/bin:$HOME/go/bin:$PATH
go version
if [ "$?" != "0" ]; then
  echo "Had problem finding go"
  exit 1
fi
