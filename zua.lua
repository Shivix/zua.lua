#!/usr/bin/env lua

DATA_FILE = "~/.local/state/zua/data"
DATA_FILE = DATA_FILE:gsub("^~", assert(os.getenv("HOME")))

local function is_directory(path)
    path = path:gsub("^~", assert(os.getenv("HOME")))
    local is_dir = os.execute("test -d '" .. path .. "'") or false
    return is_dir
end

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
    eval (zua.lua $argv)
end
function _zua_add --on-variable PWD
    zua.lua --add $PWD
end
alias z _zua_cd
    ]])
    os.exit(0)
end

-- TODO: Add to top of file when CD'd and delete bottom every so often?
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

if #arg == 2 and arg[1] == "-" or arg[1] == ".." or is_directory(arg[1]) then
    print("cd " .. arg[1])
    os.exit(0)
end

for line in data:lines() do
    for _, a in ipairs(arg) do
        if not line:lower():find(a:lower()) then
            goto next_line
        end
    end
    line = line:gsub("^~", assert(os.getenv("HOME")))
    print("cd " .. line)
    os.exit(0)
    ::next_line::
end
