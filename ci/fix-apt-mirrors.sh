#!/bin/bash
# Fix GitHub Actions failures due to broken AWS APT mirrors.
#
# See https://github.blog/changelog/2026-10-28-github-actions-adds-multi-cloud-compute-to-improve-reliability/

set -eu

files=(
	/etc/apt/apt-mirrors.txt
	/etc/apt/sources.list
	/etc/apt/sources.list.d/*
)

for file in "${files[@]}"; do
	if test ! -f "$file"; then
		printf 'file not found, skipping: %s\n' "$file"
		continue
	fi

	printf 'fixing file: %s\n' "$file"
	sudo sed -E -i 's|https?://([0-9A-Za-z-]+\.)?ec2\.archive\.ubuntu\.com/ubuntu/|http://azure.archive.ubuntu.com/ubuntu/|' "$file"
done
