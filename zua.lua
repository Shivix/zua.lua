#!/usr/bin/env lua

DATA_FILE = "~/.local/state/zua/data"
DATA_FILE = DATA_FILE:gsub("^~", assert(os.getenv("HOME")))

if #arg == 0 then
    print("cd")
end

if arg[1] == "--edit" then
    print(os.getenv("EDITOR") .. " " .. DATA_FILE)
    os.exit(0)
end

if arg[1] == "--init" then
    print([[
function _zua_cd
    if test "$argv" = -; or test "$argv" = ..
        cd $argv
        return
    end
    eval (zua.lua $argv)
end
function _zua_add --on-variable PWD
    zua.lua --add $PWD
end
alias z _zua_cd
    ]])
    os.exit(0)
end

if arg[1] == "--add" then
    local file = io.open(DATA_FILE, "r")
    if file == nil then
        os.exit(1)
    end
    for line in file:lines() do
        if line == arg[2] then
            os.exit(0)
        end
    end
    file:close()
    file = assert(io.open(DATA_FILE, "a+"))
    file:write(arg[2] .. "\n")
    os.exit(0)
end

local data = io.open(DATA_FILE, "r")

if data == nil then
    error("data_file does not exist")
end

for i, a in ipairs(arg) do
    arg[i] = a:lower()
end

for line in data:lines() do
    for _, a in ipairs(arg) do
        if not line:lower():find(a) then
            goto next_line
        end
    end
    print("cd " .. line)
    os.exit(0)
    ::next_line::
end
