#!/usr/bin/env lua
-- If you'd like to use luajit or Lua51 etc, simply change the shebang

DATA_FILE = os.getenv("ZUA_DATA_FILE") or "~/.local/state/zua/data"
DATA_FILE = DATA_FILE:gsub("^~", assert(os.getenv("HOME")))

local args = {
    case = false,
    help = false,
    patternmatch = false,
    version = false,
}
local patterns = {}
local version = "1.1.1"
local help_msg = [[
zua.lua ]] .. version .. [[

A simple and lightweight autojump tool

USAGE:
    If the shell has been configured then:
    z <pattern>...   This will match the pattern against the paths contained with $ZUA_DATA_FILE
                     and jump to the first match
    If using zua directly then:
    zua.lua [CMD] [ARGS]

CMD:
    add <path>       Adds the provided path to the data file.
    init <shell>     Outputs the required shell code to be added to shell config.
                     "fish" and "zsh" are currently supported.
    jump             Matches the patterns to a path prints a cd command for that path.
    edit             Open up the data file in $EDITOR.

ARGS:
    --case           Make the pattern case sensitive.
    --help           Prints help information.
    --patternmatch   By default zua will escape ( ) . % + - * ? [ ^ $ and match these literally.
                     This option will disable this and utilise Lua pattern matching.

ENVIRONMENT VARIABLES:
       ZUA_DEFAULT_ARGS
           Specifies the args to be provided every time zua is called through the shell function.
       ZUA_DATA_FILE
           Specifies the path to the data file to store paths in.

https://github.com/Shivix/zua.lua
]]

local function initialize()
    assert(#patterns == 1)
    local shell = patterns[1]
    if shell == "fish" then
        print([[
function _zua_cd
    if test "$argv" = -; or test "$argv" = ..
        cd $argv
        return
    end
    if test -z "$argv"
        cd
        return
    end
    eval (zua.lua jump $argv $ZUA_DEFAULT_ARGS)
end
function _zua_add --on-variable PWD
    zua.lua add $PWD/
end
alias z _zua_cd
set -gx ZUA_DATA_FILE $HOME/.local/state/zua/data
]])
    elseif shell == "zsh" then
        print([[
_zua_cd() {
    if [[ "$@" = "-" || "$@" = ".." ]] .. "]]" .. [[; then
        cd "$@"
        return
    fi
    if [[ -z "$@" ]] .. "]]" .. [[; then
        cd
        return
    fi
    eval $(zua.lua jump $@ $ZUA_DEFAULT_ARGS)
}
_zua_add() {
    zua.lua add $PWD/
}
chpwd_functions+=(_zua_add)
alias z="_zua_cd"
export ZUA_DATA_FILE="$HOME/.local/state/zua/data"
]])
    else
        error("shell not supported: " .. shell)
    end
end

local function add_path()
    local data = io.open(DATA_FILE, "r")
    if data == nil then
        error("file at $ZUA_DATA_FILE does not exist")
    end
    assert(#patterns == 1)
    local path = patterns[1]
    for line in data:lines() do
        if line == path then
            return
        end
    end
    data:close()
    data = assert(io.open(DATA_FILE, "a+"))
    data:write(path .. "\n")
end

local function find_match()
    local data = io.open(DATA_FILE, "r")
    if data == nil then
        error("file at $ZUA_DATA_FILE does not exist")
    end

    if not args.case then
        for i, pattern in ipairs(patterns) do
            patterns[i] = pattern:lower()
        end
    end

    for line in data:lines() do
        for _, a in ipairs(patterns) do
            if not args.patternmatch then
                -- Escape the magic characters and match them literally.
                a = a:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
            end
            if not line:lower():find(a) then
                goto continue
            end
        end
        -- TODO: Check if path exists, if not, delete it from data.
        -- Ensure that we only ever try to cd with a single string arg to avoid eval running any bad code.
        print("cd '" .. line:gsub("'", "'\\''") .. "'")
        os.exit()
        ::continue::
    end
end

if #arg == 0 then
    io.stderr:write(help_msg)
    os.exit(1)
end

local cmd = arg[1]
for i = 2, #arg do
    local pos = assert(arg[i]:find("[^-]"))
    if pos > 1 then
        local name = arg[i]:sub(pos, -1)
        if args[name] == nil then
            io.stderr:write(name)
            os.exit(1)
        end
        args[name] = true
    else
        table.insert(patterns, arg[i])
    end
end

if args.help then
    io.stderr:write(help_msg)
elseif args.version then
    print("echo zua.lua v" .. version)
elseif cmd == "add" then
    add_path()
elseif cmd == "edit" then
    print(os.getenv("EDITOR") .. " " .. DATA_FILE)
elseif cmd == "init" then
    initialize()
elseif cmd == "jump" then
    find_match()
else
    io.stderr:write(help_msg)
end
