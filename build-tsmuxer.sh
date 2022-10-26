#!/bin/sh

set -e
set -x

git clone --depth 1 https://github.com/justdan96/tsMuxer.git

cd tsMuxer

# set build args
export MAKEFLAGS="-j 4"

# commands directly taken from (https://github.com/justdan96/tsMuxer/blob/master/scripts/rebuild_linux_docker.sh) except for disabling the static build
rm -rf build
mkdir build
cd build
cmake -DTSMUXER_STATIC_BUILD=OFF -DFREETYPE_LDFLAGS=png ../
make
cp tsMuxer/tsmuxer ../bin/tsMuxeR
cd ..
rm -rf build
ls ./bin/tsMuxeR

# inspect the file and check the version
file ./bin/tsMuxeR
./bin/tsMuxeR --version
