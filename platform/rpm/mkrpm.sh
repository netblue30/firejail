#!/bin/bash
#
# Usage: ./mkrpm.sh
#        ./mkrpm.sh /path/to/firejail-0.9.30.tar.gz
#
# Script builds rpm in a temporary directory and places the built rpm in the
# current working directory.


source=$1

create_tmp_dir() {
    tmpdir=$(mktemp -d)
    mkdir -p ${tmpdir}/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
}


# copy or download source
if [[ $source ]]; then

    # check file exists
    if [[ ! -f $source ]]; then
        echo "$source does not exist!"
        exit 1
    fi

    name=$(awk '/Name:/ {print $2}' firejail.spec)
    version=$(awk '/Version:/ {print $2}' firejail.spec)
    expected_filename="${name}-${version}.tar.gz"

    # ensure file name matches spec file expets
    if [[ $(basename $source) != $expected_filename ]]; then
        echo "source ($source) does not match expected filename ($(basename $expected_filename))"
        exit 1
    fi

    create_tmp_dir
    cp ${source} ${tmpdir}/SOURCES
else
  create_tmp_dir
  if ! spectool -C ${tmpdir}/SOURCES -g firejail.spec; then
    echo "Failed to fetch firejail source code"
    exit 1
  fi
fi

cp ./firejail.spec "${tmpdir}/SPECS/firejail.spec"

rpmbuild --define "_topdir ${tmpdir}" -ba "${tmpdir}/SPECS/firejail.spec"

cp ${tmpdir}/RPMS/x86_64/firejail-*-1.x86_64.rpm .
rm -rf "${tmpdir}"
