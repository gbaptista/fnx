rm -rf fnx

git clone \
  -c advice.detachedHead=false \
  --depth 1 \
  --branch v0.1.3 \
  git@github.com:gbaptista/fnx.git

cd fnx

luarocks install supernova --local

fennel run/install.fnl
