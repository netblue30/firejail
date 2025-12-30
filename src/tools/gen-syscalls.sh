#!/usr/bin/env bash

# This file is part of Firejail project.
# Copyright (C) 2014-2026 Firejail Authors.
# License GPL v2.
#
# This script fetches current system calls from kernel sources then extracts and
# installs them in the src/include directory.
# Syscalls can be updated by regenerating them, ideally once before each release.
# contrib/syntax/lists/syscalls.list is synchronized too.
# It generates also etc/templates/new_syscalls.txt, this makes it easier to update
# groups and to inform users about new syscalls added.
# The script must reside in the src/tools directory and requires the cURL program.

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

if [[ "$#" -gt 0 ]]
then
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
    if compgen -G "$DEST_DIR"/syscall_*.h > /dev/null
    then
        cp "$DEST_DIR"/syscall_*.h "$TEMP_DIR"/old
    fi
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
cp "$TEMP_DIR"/syscall_parisc_32.tbl "$TEMP_DIR"/syscall_parisc_64.tbl && echo "✔ File received: syscall_parisc_64.tbl"
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

    grep --color=never -v '^[[:space:]]*#' "$table_file" | # Ignore comment lines.
    grep --color=never -E "^[^[:space:]]+[[:space:]]+($abi_1|$abi_2|$abi_3|$abi_4|$abi_5|$abi_6|$abi_7)\b" | # Keep lines with desired ABIs.
    # Fill the array.
    sed -E 's/^([0-9]+)[[:space:]]+[^[:space:]]+[[:space:]]+([^[:space:]]+).*/{ "\2", \1 },/' \
    > "$DEST_DIR"/"$firejail_header"

    echo "✔ Installed: $DEST_DIR"/"$firejail_header"

    ALL_SYSCALLS+="▶ $firejail_header\n"
    ALL_SYSCALLS+=$(
        grep --color=never -v '^[[:space:]]*#' "$table_file" |
        grep --color=never -E "^[^[:space:]]+[[:space:]]+($abi_1|$abi_2|$abi_3|$abi_4|$abi_5|$abi_6|$abi_7)\b" |
        awk '{printf "%s\t%s\t%s\n", $1, $3, $4}' # Keep column 1, 3 and 4.
    )
    ALL_SYSCALLS+=$'\n'
}

function gen_syscalls_list()
{
    local all_syscalls

    all_syscalls=$(echo -e "$ALL_SYSCALLS" | grep -v "▶" | awk '{print $2}' | sed '$d' | sort -u)
    echo "$all_syscalls" > "$SYSCALLS_LIST"

    echo "✔ Installed: $SYSCALLS_LIST"
}

# Extract the syscalls block for each header from the concatenated string.
function extract_block()
{
    local all_syscalls="$1"
    local marker="$2"

    echo -e "$all_syscalls" | awk -v mrk="▶ $marker" '
        $0 == mrk { in_block = 1; next }
        in_block && /^▶ / { exit }
        in_block && NF > 0 { print }
    '
}

function gen_new_syscalls()
{
    local all_headers header new_sysc old_header
    local syscalls_block syscalls_names old_syscalls syscall

    {
        echo "List of new system calls added after generation with the gen-syscalls.sh script."
        echo "Generated on" "$(date '+%Y-%m-%d %H:%M:%S')."
        echo "Format: <syscall number>  <syscall name>  <entry point>"
        echo
    } > "$NEW_SYSCALLS_FILE"

    all_headers=$(echo -e "$ALL_SYSCALLS" | grep "▶" | awk '{print $2}')

    while IFS= read -r header
    do
        new_sysc=0
        old_header="$TEMP_DIR"/old/"$header"

        echo "▶ $header" >> "$NEW_SYSCALLS_FILE"

        syscalls_block=$(extract_block "$ALL_SYSCALLS" "$header")
        syscalls_block=$(echo "$syscalls_block" | awk '{printf "%-5s %-32s %s\n", $1, $2, $3}' | sort -n)
        syscalls_names=$(echo "$syscalls_block" | awk '{print $2}')

        if [[ ! -f "$old_header" ]] # If the header does not exist in the old directory, add all syscalls.
        then
            {
                echo "$syscalls_block"
                echo
            } >> "$NEW_SYSCALLS_FILE"
            continue
        fi

        # Read the old header in memory.
        old_syscalls=$(<"$old_header")

        while IFS= read -r syscall
        do
            if [[ ! "$old_syscalls" =~ \"$syscall\" ]] # If the syscall is not found in the old header, add it.
            then
                echo "$syscalls_block" | grep -w "$syscall" >> "$NEW_SYSCALLS_FILE"
                new_sysc=1
            fi
        done <<< "$syscalls_names"

        if [[ "$new_sysc" -eq 0 ]] # If no new syscalls, report it.
        then
            echo "No new system calls added." >> "$NEW_SYSCALLS_FILE"
        fi

        echo >> "$NEW_SYSCALLS_FILE"
    done <<< "$all_headers"

    sed -i '$d' "$NEW_SYSCALLS_FILE" # Remove the last line.

    echo "✔ Installed: $NEW_SYSCALLS_FILE"
}

echo
echo "Extraction and installation..."
# See arch/*/kernel/Makefile.syscalls for supported ABIs by each architectures.
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
