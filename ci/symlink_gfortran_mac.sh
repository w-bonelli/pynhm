#!/usr/bin/env bash

# get full version string of the major version we just installed
# sed not head to take first line avoids ruby broken pipe issues
# (https://stackoverflow.com/a/2845541/6514033)
full_version=$(brew info gfortran | sed -n 1p | cut -d' ' -f 4)
version=$(echo "$full_version" | cut -d'.' -f 1)
echo "found gfortran version $full_version (major version $version)"

old_libdir="/usr/local/opt/gcc/lib/gcc/${version}"
new_libdir="/usr/local/lib/"
mkdir -p "$new_libdir"
echo "linking gcc dylibs $old_libdir to $new_libdir"
if [ -d "$old_libdir" ]
then
  sudo ln -fs "$old_libdir/libgfortran.5.dylib" "$new_libdir/libgfortran.5.dylib"
  sudo ln -fs "$old_libdir/libquadmath.0.dylib" "$new_libdir/libquadmath.0.dylib"
fi