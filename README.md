# install-golang

A Bash script that bootstraps and installs Go language in your home directory.

You need to have your C tool chain setup and installed already.

## Example on Debian/Ubuntu/Raspbian

This approach works for Debian style Linux hosts as well as with "Bash for Ubuntu for Windows 10".

```
    sudo apt-get install build-essentials clang zip unzip
    ./setup-golang.bash
```

## Notes for Mac OS X

As of Mac OS X Sierra booting strapping Go on a Mac is extremely painful. I recommend downloading
a pre-compile version of Go for the Mac and bootstraping from that (see https://golang.org/dl/). Once installed you can use the GOROOT_BOOTSTRAP environment variable to compile your own version of Go. I don't recommend scripting this process as it is likely to
remain an issue unless go1.4.3 gets updated to support Sierra (which seems unlikely form the discussion lists)

This assumes Apples' Mac Developer Tools (XCode for command line) are installed, the compiled version you've installed is
the latest and that you want to compile your own go1.8.

```
    export GOROOT_BOOTSTRAP=/usr/local/go
    cd $HOME
    git clone https://github.com/golang/go go
    cd go
    git checkout go1.8
    cd src
    ./all.bash
```

This should then compile your personal Go in your home directory and you can remove the ports version.

```
    sudo /bin.rm -fR /usr/local/go # or if you've used Mac Ports try, sudo port uninstall go@1.8
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
