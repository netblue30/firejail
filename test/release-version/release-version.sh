#!/bin/sh

set -eu

readonly VERSION_PATTERN='s/^firejail configure //p'
readonly MISMATCH_SUFFIX='-mismatch'
readonly ERROR_EXIT_STATUS=1

printf 'TESTING: release tag matches package version\n'

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
readonly ROOT
readonly CHECK_RELEASE_VERSION="$ROOT/ci/check/release-version.sh"

configure_version=$("$ROOT/configure" --version)
PACKAGE_VERSION=$(printf '%s\n' "$configure_version" | sed -n "$VERSION_PATTERN")
readonly PACKAGE_VERSION
if test -z "$PACKAGE_VERSION"; then
	printf 'TESTING ERROR: cannot determine package version\n' >&2
	exit "$ERROR_EXIT_STATUS"
fi
readonly MISMATCHED_TAG="${PACKAGE_VERSION}${MISMATCH_SUFFIX}"
readonly EXPECTED_ERROR="error: release tag $MISMATCHED_TAG does not match package version $PACKAGE_VERSION"

output=$(
	"$CHECK_RELEASE_VERSION" "$MISMATCHED_TAG" "$ROOT/configure.ac" 2>&1
) && {
	printf 'TESTING ERROR: expected mismatched release version to fail\n' >&2
	exit "$ERROR_EXIT_STATUS"
}

if test "$output" != "$EXPECTED_ERROR"; then
	printf 'TESTING ERROR: unexpected error: %s\n' "$output" >&2
	exit "$ERROR_EXIT_STATUS"
fi

"$CHECK_RELEASE_VERSION" "$PACKAGE_VERSION" "$ROOT/configure.ac"
