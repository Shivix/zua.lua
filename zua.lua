#!/usr/bin/env lua

local argparser = require("lualib.args").parse_args

DATA_FILE = os.getenv("ZUA_DATA_FILE") or "~/.local/state/zua/data"
DATA_FILE = DATA_FILE:gsub("^~", assert(os.getenv("HOME")))

local options = {
    help = {
        short = "h",
    },
    version = {
        short = "v",
    },
}

local version = "1.0.0"
local help_msg = [[
zua ]] .. version .. [[

A simple and lightweight autojump tool

Usage:
    zua [Command] [Options]

Commands:
    add <path>         Adds the provided path to the data file.
    init <shell>       Outputs the required shell code to be added to shell config.
                       "fish" and "zsh" are currently supported.
    edit               Open up the data file in $EDITOR.

Options:
    --help             Prints help information.
    --version          Prints version information.

ENVIRONMENT VARIABLES:
       ZUA_DATA_FILE
           Specifies the path to the data file to store paths in.

https://github.com/Shivix/zua.lua
]]

local function initialize()
    return [[
function _zua_add --on-variable PWD
    zua add $PWD/
end
if not set -q ZUA_DATA_FILE
    set -gx ZUA_DATA_FILE $HOME/.local/state/zua/data
end
]]
end

local function add_path(path)
    assert(type(path) == "string")
    local data = io.open(DATA_FILE, "r")
    if data == nil then
        error("file at $ZUA_DATA_FILE does not exist")
    end
    for line in data:lines() do
        if line == path then
            return
        end
    end
    data:close()
    data = assert(io.open(DATA_FILE, "a+"))
    data:write(path .. "\n")
    data:close()
    os.execute("sort " .. DATA_FILE .. " -o " .. DATA_FILE)
end

if #arg == 0 then
    io.stderr:write(help_msg)
    os.exit(1)
end

local opts, args = argparser(options)
local cmd = args[1]

if opts.help then
    print(help_msg)
elseif opts.version then
    print("zua version " .. version)
elseif cmd == "add" then
    add_path(args[2])
elseif cmd == "edit" then
    os.execute(os.getenv("EDITOR") .. " " .. DATA_FILE)
elseif cmd == "init" then
    print(initialize())
else
    if cmd == "" then
        io.stderr:write(help_msg)
    else
        io.stderr:write("invalid command: " .. cmd .. "\n")
    end
end
