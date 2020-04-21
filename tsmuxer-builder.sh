#!/bin/bash

set -e
set -o pipefail

export DEBIAN_FRONTEND=noninteractive

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"

usage() {
    echo "usage: $(basename $0) OUTPUT_DIR [ROOT_EXEC_DIR]

  Arguments:
    OUTPUT_DIR     Directory where the tarball will be copied to.
    ROOT_EXEC_DIR  Root directory where tsMuxeR will be located at execution
                   time.  Default: '/opt/tsmuxer'.
"
}

# Validate script arguments.
if [ -z "$1" ]; then
    echo "ERROR: Output directory must be specified."
    usage
    exit 1
elif [ -n "$2" ] && [[ $2 != /* ]]; then
    echo "ERROR: Invalid root execution directory."
    usage
    exit 1
fi

TARBALL_DIR="$1"
ROOT_EXEC_DIR="${2:-/opt/tsmuxer}"
INSTALL_BASEDIR=/tmp/tsmuxer-install
INSTALL_DIR=$INSTALL_BASEDIR$ROOT_EXEC_DIR

mkdir -p "$TARBALL_DIR"
mkdir -p "$INSTALL_DIR"

# Need to import 32-bit packages.
dpkg --add-architecture i386

echo "Updating APT cache..."
apt-get update

echo "Installing prerequisites..."
apt-get install -y --no-install-recommends \
    software-properties-common \
    sudo \
    patchelf

echo "Installing tsMuxeR..."
add-apt-repository -y ppa:robert-tari/main
apt-get update
apt-get install -y --no-install-recommends tsmuxer
mkdir -p "$INSTALL_DIR/bin"
cp -v /usr/bin/tsMuxeR "$INSTALL_DIR/bin/"

EXTRA_LIBS="/lib/ld-linux.so.2"

# Package library dependencies
echo "Extracting shared library dependencies..."
mkdir -p "$INSTALL_DIR/lib"
DEPS="$(LD_TRACE_LOADED_OBJECTS=1 "$INSTALL_DIR/bin/tsMuxeR" | grep " => " | cut -d'>' -f2 | sed 's/^[[:space:]]*//' | cut -d'(' -f1 | grep '^/usr\|^/lib')"
for dep in $DEPS $EXTRA_LIBS
do
    dep_real="$(realpath "$dep")"
    dep_basename="$(basename "$dep_real")"

    # Skip already-processed libraries.
    [ ! -f "$INSTALL_DIR/lib/$dep_basename" ] || continue

    echo "  -> Found library: $dep"
    cp "$dep_real" "$INSTALL_DIR/lib/"
    while true; do
        [ -L "$dep" ] || break;
        ln -sf "$dep_basename" "$INSTALL_DIR"/lib/$(basename $dep)
        dep="$(readlink -f "$dep")"
    done
done

# Since the interpreter can't be changed in binaries, we need to add it to the
# standard location.
mkdir -p "$INSTALL_BASEDIR/lib"
ln -sf "$ROOT_EXEC_DIR/lib/ld-linux.so.2" "$INSTALL_BASEDIR/lib/ld-linux.so.2"

echo "Patching ELF of libraries..."
find "$INSTALL_DIR/lib" -type f -exec echo {} \; -exec patchelf --set-interpreter /lib/ld-linux.so.2 {} \;

# Wrappers is needed because rpath can't be set in binaries.
echo "Creating wrappers..."
cat << 'EOF' > "$INSTALL_DIR/tsMuxeR"
#!/bin/sh
exec env LD_LIBRARY_PATH=/opt/ums/linux/lib /opt/ums/linux/bin/tsMuxeR "$@"
EOF
chmod +x "$INSTALL_DIR/tsMuxeR"
