#!/bin/bash
set -e
set -x

# Build Icecast from source
apt-get install -q -y --no-install-recommends \
   build-essential libxml2 libxslt1-dev libvorbis-dev libssl-dev libcurl4-openssl-dev openssl

mkdir -p /bd_build/stations/icecast_build
cd /bd_build/stations/icecast_build

# curl -fsSL https://github.com/karlheyes/icecast-kh/archive/refs/tags/icecast-2.4.0-kh20.5.tar.gz \
#   -o icecast.tar.gz
# tar -xvzf icecast.tar.gz --strip-components=1

git clone https://github.com/karlheyes/icecast-kh.git .
git checkout b28cc11a7fd4809cd501fe79a77b1b6bbb1fbb71

./configure
make
make install

# Remove build tools
apt-get remove --purge -y build-essential libxslt1-dev libvorbis-dev libssl-dev libcurl4-openssl-dev

# Copy AzuraCast Icecast customizations
mkdir -p /bd_build/stations/icecast_customizations
cd /bd_build/stations/icecast_customizations

# git clone https://github.com/AzuraCast/icecast-kh-custom-files.git .

curl -fsSL https://github.com/AzuraCast/icecast-kh-custom-files/archive/refs/tags/2023-01-21.tar.gz \
  -o custom-files.tar.gz
tar -xvzf custom-files.tar.gz --strip-components=1

cp -r web/* /usr/local/share/icecast/web
