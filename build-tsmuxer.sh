#!/bin/sh

set -e
set -x

git clone --depth 1 https://github.com/justdan96/tsMuxer.git

# build commands taken from https://github.com/justdan96/tsMuxer/blob/master/rebuild_linux.sh
cd tsMuxer
rm -rf build
mkdir build
cd build
cmake ../ -G Ninja -DTSMUXER_STATIC_BUILD=true
ninja
cp tsMuxer/tsmuxer ../bin/tsMuxeR
cd ..
rm -rf build
file ./bin/tsMuxeR
./bin/tsMuxeR --version
