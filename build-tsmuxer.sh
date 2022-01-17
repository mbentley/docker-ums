#!/bin/sh

set -e
set -x

# last commit that works (until I have figured out https://github.com/justdan96/tsMuxer/issues/543)
git clone --depth 1 --branch nightly-2022-01-11-02-11-13 https://github.com/justdan96/tsMuxer.git

# doesn't work (see above)
#git clone --depth 1 https://github.com/justdan96/tsMuxer.git

cd tsMuxer

# set build args
export MAKEFLAGS="-j 4"

# execute script from repo
./rebuild_linux_docker.sh

file ./bin/tsMuxeR
./bin/tsMuxeR --version
