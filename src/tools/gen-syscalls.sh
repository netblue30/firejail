#!/usr/bin/env bash

# This file is part of Firejail project.
# Copyright (C) 2014-2025 Firejail Authors.
# License GPL v2.
#
# This script fetches current system calls from kernel sources then extracts and
# installs them in the src/include directory.
# Syscalls can be updated by regenerating them, ideally once before each release.
# contrib/syntax/lists/syscalls.list is synchronized too.
# It generates also etc/templates/new_syscalls.txt, this makes it easier to update
# groups and to inform users about new syscalls added.
# The script must reside in the src/tools directory and requires the cURL CLI program.

set -e
export LC_ALL=C

function usage()
{
    echo "Usage: gen-syscalls.sh"
    echo "Generate system calls for several architectures to be used with Firejail."
    echo
    echo "Options:"
    echo "  -h, --help    Show this help."
}

if [[ "$#" -gt 1 ]]
then
    echo "✖ Too many arguments. Use -h for help." >&2
    exit 1
fi

if [[ "$1" = "-h" || "$1" = "--help" ]]
then
    usage
    exit 0
fi

if [[ "$#" -gt 0 ]]; then
    echo "✖ Invalid argument: $1. Use -h for help." >&2
    exit 1
fi

CURL=$(type -P curl)
BASE_URL="https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/plain"
TEMP_DIR=$(mktemp -d /tmp/gen-syscalls.XXXXXX)
SCRIPT_DIR=$(dirname "$0")
DEST_DIR=$(realpath "$SCRIPT_DIR"/../include)
SYSCALLS_LIST_DIR=$(realpath "$SCRIPT_DIR"/../../contrib/syntax/lists)
SYSCALLS_LIST="$SYSCALLS_LIST_DIR"/syscalls.list
ALL_SYSCALLS=""
NEW_SYSCALLS_DIR=$(realpath "$SCRIPT_DIR"/../../etc/templates)
NEW_SYSCALLS_FILE="$NEW_SYSCALLS_DIR"/new_syscalls.txt

if [[ ! -x "$CURL" ]]
then
    echo "✖ cURL program not found, script stopped." >&2
    exit 127
fi

if [[ ! -d "$TEMP_DIR" ]]
then
    echo "✖ Temp directory not found, script stopped." >&2
    exit 1
else
    mkdir "$TEMP_DIR"/old
    cp "$DEST_DIR"/syscall_*.h "$TEMP_DIR"/old
fi

if [[ ! -d "$DEST_DIR" ]]
then
    echo "✖ Destination directory not found, script stopped." >&2
    exit 1
fi

if [[ ! -d "$SYSCALLS_LIST_DIR" ]]
then
    echo "✖ Directory not found for syscalls.list, script stopped." >&2
    exit 1
fi

if [[ ! -d "$NEW_SYSCALLS_DIR" ]]
then
    echo "✖ Directory not found for new_syscalls.txt, script stopped." >&2
    exit 1
fi

echo "Downloading syscalls tables from kernel sources..."
"$CURL" --no-progress-meter "$BASE_URL"/arch/arm64/tools/syscall_32.tbl -o "$TEMP_DIR"/syscall_aarch32.tbl
echo "✔ File received: syscall_aarch32.tbl"
# The next one is for arc, arm64, csky, hexagon, loongarch, nios2, openrisc and riscv architectures.
# See https://docs.kernel.org/process/adding-syscalls.html#since-6-11
"$CURL" --no-progress-meter "$BASE_URL"/scripts/syscall.tbl -o "$TEMP_DIR"/syscall_aarch64.tbl
echo "✔ File received: syscall_aarch64.tbl"
"$CURL" --no-progress-meter "$BASE_URL"/arch/alpha/kernel/syscalls/syscall.tbl -o "$TEMP_DIR"/syscall_alpha.tbl
echo "✔ File received: syscall_alpha.tbl"
cp "$TEMP_DIR"/syscall_aarch64.tbl "$TEMP_DIR"/syscall_arc_32.tbl && echo "✔ File received: syscall_arc_32.tbl"
"$CURL" --no-progress-meter "$BASE_URL"/arch/arm/tools/syscall.tbl -o "$TEMP_DIR"/syscall_armeabi.tbl
echo "✔ File received: syscall_armeabi.tbl"
cp "$TEMP_DIR"/syscall_armeabi.tbl "$TEMP_DIR"/syscall_armoabi.tbl && echo "✔ File received: syscall_armoabi.tbl"
cp "$TEMP_DIR"/syscall_aarch64.tbl "$TEMP_DIR"/syscall_csky.tbl && echo "✔ File received: syscall_csky.tbl"
cp "$TEMP_DIR"/syscall_aarch64.tbl "$TEMP_DIR"/syscall_hexagon_32.tbl && echo "✔ File received: syscall_hexagon_32.tbl"
"$CURL" --no-progress-meter "$BASE_URL"/arch/x86/entry/syscalls/syscall_32.tbl -o "$TEMP_DIR"/syscall_i386.tbl
echo "✔ File received: syscall_i386.tbl"
cp "$TEMP_DIR"/syscall_aarch64.tbl "$TEMP_DIR"/syscall_loongarch_64.tbl && echo "✔ File received: syscall_loongarch_64.tbl"
"$CURL" --no-progress-meter "$BASE_URL"/arch/m68k/kernel/syscalls/syscall.tbl -o "$TEMP_DIR"/syscall_m68k.tbl
echo "✔ File received: syscall_m68k.tbl"
"$CURL" --no-progress-meter "$BASE_URL"/arch/microblaze/kernel/syscalls/syscall.tbl -o "$TEMP_DIR"/syscall_microblaze.tbl
echo "✔ File received: syscall_microblaze.tbl"
"$CURL" --no-progress-meter "$BASE_URL"/arch/mips/kernel/syscalls/syscall_n32.tbl -o "$TEMP_DIR"/syscall_mips_n32.tbl
echo "✔ File received: syscall_mips_n32.tbl"
"$CURL" --no-progress-meter "$BASE_URL"/arch/mips/kernel/syscalls/syscall_n64.tbl -o "$TEMP_DIR"/syscall_mips_n64.tbl
echo "✔ File received: syscall_mips_n64.tbl"
"$CURL" --no-progress-meter "$BASE_URL"/arch/mips/kernel/syscalls/syscall_o32.tbl -o "$TEMP_DIR"/syscall_mips_o32.tbl
echo "✔ File received: syscall_mips_o32.tbl"
cp "$TEMP_DIR"/syscall_aarch64.tbl "$TEMP_DIR"/syscall_nios2.tbl && echo "✔ File received: syscall_nios2.tbl"
cp "$TEMP_DIR"/syscall_aarch64.tbl "$TEMP_DIR"/syscall_openrisc_32.tbl && echo "✔ File received: syscall_openrisc_32.tbl"
"$CURL" --no-progress-meter "$BASE_URL"/arch/parisc/kernel/syscalls/syscall.tbl -o "$TEMP_DIR"/syscall_parisc_32.tbl
echo "✔ File received: syscall_parisc_32.tbl"
"$CURL" --no-progress-meter "$BASE_URL"/arch/parisc/kernel/syscalls/syscall.tbl -o "$TEMP_DIR"/syscall_parisc_64.tbl
echo "✔ File received: syscall_parisc_64.tbl"
"$CURL" --no-progress-meter "$BASE_URL"/arch/powerpc/kernel/syscalls/syscall.tbl -o "$TEMP_DIR"/syscall_powerpc_32_nospu.tbl
echo "✔ File received: syscall_powerpc_32_nospu.tbl"
cp "$TEMP_DIR"/syscall_powerpc_32_nospu.tbl "$TEMP_DIR"/syscall_powerpc_64_nospu.tbl && echo "✔ File received: syscall_powerpc_64_nospu.tbl"
cp "$TEMP_DIR"/syscall_aarch64.tbl "$TEMP_DIR"/syscall_riscv_32.tbl && echo "✔ File received: syscall_riscv_32.tbl"
cp "$TEMP_DIR"/syscall_aarch64.tbl "$TEMP_DIR"/syscall_riscv_64.tbl && echo "✔ File received: syscall_riscv_64.tbl"
"$CURL" --no-progress-meter "$BASE_URL"/arch/s390/kernel/syscalls/syscall.tbl -o "$TEMP_DIR"/syscall_s390_32.tbl
echo "✔ File received: syscall_s390_32.tbl"
cp "$TEMP_DIR"/syscall_s390_32.tbl "$TEMP_DIR"/syscall_s390_64.tbl && echo "✔ File received: syscall_s390_64.tbl"
"$CURL" --no-progress-meter "$BASE_URL"/arch/sparc/kernel/syscalls/syscall.tbl -o "$TEMP_DIR"/syscall_sparc_32.tbl
echo "✔ File received: syscall_sparc_32.tbl"
cp "$TEMP_DIR"/syscall_sparc_32.tbl "$TEMP_DIR"/syscall_sparc_64.tbl && echo "✔ File received: syscall_sparc_64.tbl"
"$CURL" --no-progress-meter "$BASE_URL"/arch/sh/kernel/syscalls/syscall.tbl -o "$TEMP_DIR"/syscall_superh.tbl
echo "✔ File received: syscall_superh.tbl"
"$CURL" --no-progress-meter "$BASE_URL"/arch/x86/entry/syscalls/syscall_64.tbl -o "$TEMP_DIR"/syscall_x86_64.tbl
echo "✔ File received: syscall_x86_64.tbl"
"$CURL" --no-progress-meter "$BASE_URL"/arch/xtensa/kernel/syscalls/syscall.tbl -o "$TEMP_DIR"/syscall_xtensa.tbl
echo "✔ File received: syscall_xtensa.tbl"

function extract_and_install()
{
    local table_file="$TEMP_DIR"/"$1"
    local abi_1="$2"
    local abi_2="${3:-$abi_1}"
    local abi_3="${4:-$abi_1}"
    local abi_4="${5:-$abi_1}"
    local abi_5="${6:-$abi_1}"
    local abi_6="${7:-$abi_1}"
    local abi_7="${8:-$abi_1}"
    local table_file_basen
    table_file_basen=$(basename "$table_file")
    local firejail_header="${table_file_basen%.*}".h

    cat "$table_file" \
    | grep --color=never -v '^[[:space:]]*#' \
    | grep --color=never -E "^[^[:space:]]+[[:space:]]+($abi_1|$abi_2|$abi_3|$abi_4|$abi_5|$abi_6|$abi_7)\b" \
    | sed -E 's/^([0-9]+)[[:space:]]+[^[:space:]]+[[:space:]]+([^[:space:]]+).*/{ "\2", \1 },/' \
    > "$DEST_DIR"/"$firejail_header"

    echo "✔ Installed: $DEST_DIR"/"$firejail_header"

    ALL_SYSCALLS+=$(
        cat "$table_file" \
        | grep --color=never -v '^[[:space:]]*#' \
        | grep --color=never -E "^[^[:space:]]+[[:space:]]+($abi_1|$abi_2|$abi_3|$abi_4|$abi_5|$abi_6|$abi_7)\b" \
        | sed -E 's/^([^[:space:]]+[[:space:]]+){2}([^[:space:]]+).*/\2/'
    )

    ALL_SYSCALLS+=$'\n'
}

function gen_syscalls_list()
{
    ALL_SYSCALLS=$(echo "$ALL_SYSCALLS" | sed '$d' | sort -u)
    echo "$ALL_SYSCALLS" > "$SYSCALLS_LIST"

    echo "✔ Installed: $SYSCALLS_LIST"
}

# Extract the string in quotation marks on lines: { "xxx", N },
function extract_words() {
    awk -F'"' '
    /^\s*\{\s*"/ { print $2 }
    ' "$1" | sort -u
}

function gen_new_syscalls()
{
    local f1 f2 base missing

    echo "List of new system calls added after generation with the gen-syscalls.sh script." > "$NEW_SYSCALLS_FILE"
    echo "Generated on" $(date +"%Y-%m-%d %H:%M:%S")"." >> "$NEW_SYSCALLS_FILE"
    echo >> "$NEW_SYSCALLS_FILE"

    for f2 in "$DEST_DIR"/syscall_*.h; do
        base="${f2##*/}"
        f1="$TEMP_DIR"/old/"$base"

        echo "▶ $base" >> "$NEW_SYSCALLS_FILE"

        if [[ -f "$f1" ]]
        then
            missing=$(comm -13 <(extract_words "$f1") <(extract_words "$f2"))
            if [[ -n "$missing" ]]
            then
                # If file exists in the old directory, add missing syscalls.
                echo "$missing" >> "$NEW_SYSCALLS_FILE"
            else
                echo "No new system calls added." >> "$NEW_SYSCALLS_FILE"
            fi
        else
            # If file is missing in the old directory, add all syscalls.
            extract_words "$f2" >> "$NEW_SYSCALLS_FILE"
        fi

        echo >> "$NEW_SYSCALLS_FILE"
    done

    # Remove the last line.
    sed -i '$d' "$NEW_SYSCALLS_FILE"

    echo "✔ Installed: $NEW_SYSCALLS_FILE"
}

echo
echo "Extraction and installation..."
# See arch/*/kernel/Makefile.syscalls for supported pseudo-ABIs by architectures.
extract_and_install "syscall_aarch32.tbl" "common" # Corresponds to syscall_armeabi.tbl.
extract_and_install "syscall_aarch64.tbl" "common" "64" "renameat" "rlimit" "memfd_secret"
extract_and_install "syscall_alpha.tbl" "common"
extract_and_install "syscall_arc_32.tbl" "common" "32" "arc" "time32" "renameat" "stat64" "rlimit"
extract_and_install "syscall_armeabi.tbl" "common" "eabi"
extract_and_install "syscall_armoabi.tbl" "common" "oabi"
extract_and_install "syscall_csky.tbl" "common" "32" "csky" "time32" "stat64" "rlimit"
extract_and_install "syscall_hexagon_32.tbl" "common" "32" "hexagon" "time32" "stat64" "rlimit" "renameat"
extract_and_install "syscall_i386.tbl" "i386"
extract_and_install "syscall_loongarch_64.tbl" "common" "64"
extract_and_install "syscall_m68k.tbl" "common"
extract_and_install "syscall_microblaze.tbl" "common"
extract_and_install "syscall_mips_n32.tbl" "n32"
extract_and_install "syscall_mips_n64.tbl" "n64"
extract_and_install "syscall_mips_o32.tbl" "o32"
extract_and_install "syscall_nios2.tbl" "common" "32" "nios2" "time32" "stat64" "renameat" "rlimit"
extract_and_install "syscall_openrisc_32.tbl" "common" "32" "or1k" "time32" "stat64" "rlimit" "renameat"
extract_and_install "syscall_parisc_32.tbl" "common" "32"
extract_and_install "syscall_parisc_64.tbl" "common" "64"
extract_and_install "syscall_powerpc_32_nospu.tbl" "common" "32" "nospu"
extract_and_install "syscall_powerpc_64_nospu.tbl" "common" "64" "nospu"
extract_and_install "syscall_riscv_32.tbl" "common" "32" "riscv" "memfd_secret"
extract_and_install "syscall_riscv_64.tbl" "common" "64" "riscv" "rlimit" "memfd_secret"
extract_and_install "syscall_s390_32.tbl" "common" "32"
extract_and_install "syscall_s390_64.tbl" "common" "64"
extract_and_install "syscall_sparc_32.tbl" "common" "32"
extract_and_install "syscall_sparc_64.tbl" "common" "64"
extract_and_install "syscall_superh.tbl" "common"
extract_and_install "syscall_x86_64.tbl" "common" "64"
extract_and_install "syscall_xtensa.tbl" "common"
gen_syscalls_list
gen_new_syscalls

exit 0
