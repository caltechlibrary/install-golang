# install-golang

A Bash script that bootstraps and installs Go language in your home directory.

You need to have your C tool chain setup and installed already.

## Example on Debian/Ubuntu/Raspbian

```
    sudo apt-get install build-essentials
    ./install-golang.bash
```

## Mac OS X ports

On a Mac you need [Mac Ports](https://www.macports.org/) and Apples' Mac Developer Tools (XCode for command line) installed.

```
    ./install-golang.bash
```


## After installation

You'll want to set your *GOPATH* variable. I usually set it to that same as *HOME* and put this in my *.bashrc* file (or *.profile*).
If you want to have the *go install* command work you will need to have *GOBIN* set and I often set this to *$HOME/bin*.

```shell
    #
    # Typical Golang setup
    #
    export GOPATH=$HOME
    export GOBIN=$HOME/bin
```


