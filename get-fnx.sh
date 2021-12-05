git clone git@github.com:gbaptista/fnx.git

cd fnx

luarocks install luafilesystem --local
luarocks install supernova --local

fennel install.fnl
