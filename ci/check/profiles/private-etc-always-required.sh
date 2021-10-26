#!/bin/bash

ALWAYS_REQUIRED=(alternatives ld.so.cache ld.so.preload)

error=0
while IFS=: read -r profile private_etc; do
	for required in "${ALWAYS_REQUIRED[@]}"; do
		if grep -q -v -E "( |,)$required(,|$)" <<<"$private_etc"; then
			printf '%s misses %s\n' "$profile" "$required" >&2
			error=1
		fi
	done
done < <(grep "^private-etc " "$@")

exit "$error"
