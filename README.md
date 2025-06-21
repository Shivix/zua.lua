# Zua.lua
A simple, lightweight and predictable autojump tool.

This simple branch contains a stripped down version of zua that matches my personal use case.

## Usage
Install zua.lua somewhere your shell can find it. A Makefile is provided that installs it to /usr/local/bin.

Add the following line to your shell config:
```fish
# Fish
zua init fish | source
```

Paths will be added to the data file whenever your current working directory changes.

`$ZUA_DATA_FILE` Environment variable may be set to adjust where the paths are stored.

## Issues
Any bugs/ requests can be added to the [issues](https://github.com/Shivix/zua.lua/issues) page on the GitHub repository.\
Note that feature requests will be highly but fairly scrutinized. The number one focus here is to be simple and lightweight.
