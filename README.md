# Zua.lua

A simple, lightweight and predictable autojump tool.

## Usage
Install zua.lua somewhere your shell can find it. A Makefile is provided that installs it to /usr/local/bin.

Add one of the following lines to your shell config:
```bash
# Fish
zua.lua init fish | source
# Zsh
source <(zua.lua init zsh)
```

Paths will be added to the data file whenever you `cd` into a new directory.\
Then you can give zua a pattern or number of patterns and zua will cd into the first path that matches all patterns.
```bash
$ zua <pattern>
```

Supports opt in pattern matching on file matching and opt in case sensitivity.\
See `zua.lua --help` for details.\
`$ZUA_DEFAULT_ARGS` Environment variable may be set to adjust default behaviour.\
`$ZUA_DATA_FILE` Environment variable may be set to adjust where the paths are stored.

## Issues
Any bugs/ requests can be added to the [issues](https://github.com/Shivix/prefix/issues) page on the GitHub repository.\
Note that feature requests will be highly but fairly scrutinized. The number one focus here is to be simple and lightweight.
