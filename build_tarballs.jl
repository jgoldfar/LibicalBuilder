# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "LibicalBuilder"
version = v"3.0.0"

# Collection of sources required to build LibicalBuilder
sources = [
    "https://github.com/libical/libical/archive/3.0.zip" =>
    "c23d077479635b95e3819838d7b00e7a6c273a029f4ed497a90a575eed3f8c0c",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/libical-3.0/
mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=$prefix -DCMAKE_TOOLCHAIN_FILE=/opt/$target/$target.toolchain -D ICAL_GLIB=OFF ..
make
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, :glibc),
    MacOS(:x86_64),
    FreeBSD(:x86_64),
    Windows(:i686),
    Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libical", :libical)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

