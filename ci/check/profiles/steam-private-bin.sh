#!/bin/sh

readonly REQUIRED_PROGRAM='perl'
readonly PRIVATE_BIN_PREFIX='#private-bin '
readonly PROGRAM_SEPARATOR=','

awk -v prefix="$PRIVATE_BIN_PREFIX" -v required="$REQUIRED_PROGRAM" \
	-v separator="$PROGRAM_SEPARATOR" '
	index($0, prefix) == 1 {
		count = split(substr($0, length(prefix) + 1), programs, separator)
		for (i = 1; i <= count; i++) {
			if (programs[i] == required)
				found = 1
		}
	}
	END { exit !found }
' "$1"
