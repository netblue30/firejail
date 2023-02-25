#!/bin/bash
# This file is part of Firejail project
# Copyright (C) 2014-2023 Firejail Authors
# License GPL v2
#
# Usage: ./platform/rpm/mkrpm.sh firejail <version> "<config options>"
#
# Builds rpms in a temporary directory then places the result in the
# current working directory.

name=$1
# Strip any trailing prefix from the version like -rc1 etc
version=$(echo "$2" | sed 's/\-.*//g')
config_opt=$3

if [[ ! -f platform/rpm/${name}.spec ]]; then
    echo error: spec file not found for name \"${name}\"
    exit 1
fi

if [[ -z "${version}" ]]; then
    echo error: version must be given
    exit 1
fi

if [[ -z "${config_opt}" ]]; then
    config_opt="--disable-userns --disable-contrib-install"
fi

# Make a temporary directory and arrange to clean up on exit
tmpdir=$(mktemp -d)
mkdir -p ${tmpdir}/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
function cleanup {
    rm -rf ${tmpdir}
}
trap cleanup EXIT

# Create the spec file
tmp_spec_file=${tmpdir}/SPECS/${name}.spec
sed -e "s/__NAME__/${name}/g" \
    -e "s/__VERSION__/${version}/g" \
    -e "s/__CONFIG_OPT__/${config_opt}/g" \
    platform/rpm/${name}.spec >${tmp_spec_file}
# FIXME: We could parse RELNOTES and create a %changelog section here

# Copy the source to build into a tarball
tar --exclude='./.git*' --transform "s/^./${name}-${version}/" -czf ${tmpdir}/SOURCES/${name}-${version}.tar.gz .

# Build the files (rpm, debug rpm and source rpm)
rpmbuild --quiet --define "_topdir ${tmpdir}" -ba ${tmp_spec_file}

# Copy the results to cwd
mv ${tmpdir}/SRPMS/*.rpm ${tmpdir}/RPMS/*/*rpm .
