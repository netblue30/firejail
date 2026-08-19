#!/bin/sh

set -eu

readonly USAGE="usage: $0 TAG CONFIGURE_AC"
readonly VERSION_PATTERN='s/^AC_INIT(\[firejail\], \[\([^]]*\)\].*/\1/p'
readonly EXPECTED_ARGUMENT_COUNT=2
readonly USAGE_EXIT_STATUS=2

if test "$#" -ne "$EXPECTED_ARGUMENT_COUNT"; then
	printf '%s\n' "$USAGE" >&2
	exit "$USAGE_EXIT_STATUS"
fi

readonly RELEASE_TAG=$1
readonly CONFIGURE_AC=$2

if ! test -r "$CONFIGURE_AC"; then
	printf 'error: cannot read %s\n' "$CONFIGURE_AC" >&2
	exit "$USAGE_EXIT_STATUS"
fi

package_version=$(sed -n "$VERSION_PATTERN" "$CONFIGURE_AC")
if test -z "$package_version"; then
	printf 'error: cannot determine package version from %s\n' "$CONFIGURE_AC" >&2
	exit "$USAGE_EXIT_STATUS"
fi

if test "$RELEASE_TAG" != "$package_version"; then
	printf 'error: release tag %s does not match package version %s\n' \
		"$RELEASE_TAG" "$package_version" >&2
	exit 1
fi
