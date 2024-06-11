#!/usr/bin/env lua
-- If you'd like to use luajit or Lua51 etc, simply change the shebang

DATA_FILE = "~/.local/state/zua/data"
DATA_FILE = DATA_FILE:gsub("^~", assert(os.getenv("HOME")))

if #arg == 0 then
    print("cd")
end

local args = {
    add = false,
    case = false,
    edit = false,
    init = false,
    help = false,
    patternmatch = false,
}
local patterns = {}
local help_msg = [[
zua 1.0.1
A simple and lightweight autojump tool

USAGE:
    zua [OPTIONS] [pattern]...

ARGS:
    <pattern>...   A set of patterns that must all match part of a path.


OPTIONS:
    --add          Adds the provided path to the data file.
    --case         Make the pattern case sensitive.
    --edit         Open up the data file in $EDITOR.
    --init         Outputs the required shell code to be added to shell config.
                   (Only Fish supported currently)
    --help         Prints help information.
    --patternmatch By default zua will escape ( ) . % + - * ? [ ^ $ and match these literally.
                   This option will disable this and utilise Lua pattern matching.

ENVIRONMENT VARIABLES:
       ZUA_DEFAULT_ARGS
           Specifies the args to be provided every time zua is called through the shell function
]]

local function initialize()
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
    eval (zua.lua $argv $ZUA_DEFAULT_ARGS)
end
function _zua_add --on-variable PWD
    zua.lua --add $PWD
end
alias z _zua_cd
]])
end

local function add_path()
    local data = io.open(DATA_FILE, "r")
    if data == nil then
        error("data_file does not exist")
    end
    if args.add then
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
end

local function find_match()
    local data = io.open(DATA_FILE, "r")
    if data == nil then
        error("data_file does not exist")
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
        print("cd " .. line)
        os.exit()
        ::continue::
    end
end

for _, a in ipairs(arg) do
    local pos = assert(a:find("[^-]"))
    if pos ~= 1 then
        local name = a:sub(pos, -1)
        if args[name] == nil then
            io.stderr:write(help_msg)
            os.exit(1)
        end
        args[name] = true
    else
        table.insert(patterns, a)
    end
end

if args.help then
    print(help_msg)
elseif args.edit then
    print(os.getenv("EDITOR") .. " " .. DATA_FILE)
elseif args.add then
    add_path()
elseif args.init then
    initialize()
else
    find_match()
end
