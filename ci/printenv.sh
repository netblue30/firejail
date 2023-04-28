#!/bin/sh
# Print information that may be useful for debugging CI.

test -f /etc/os-release && . /etc/os-release

cat <<EOF
nproc:  $(nproc)
kernel: $(uname -srvm)
distro: $PRETTY_NAME
sh:     $(ls -l /bin/sh | sed 's|.* /bin|/bin|')
user:   $(id | cut -f -2 -d ' ')

[/etc/os-release]
$(cat /etc/os-release)
EOF

if test -z "$CI_VERBOSE"; then
	exit
fi

cat <<EOF

[env]
$(env | LC_ALL=C sort)
EOF
