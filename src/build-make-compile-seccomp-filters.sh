#!/bin/sh

set -e

fseccomp="$1"
fsec_optimize="$2"
outdir="$3"

cd "$outdir" || exit 1

# seccomp
$fseccomp default seccomp
$fsec_optimize seccomp

# seccomp.debug
$fseccomp default seccomp.debug allow-debuggers
$fsec_optimize seccomp.debug

# seccomp.32
$fseccomp secondary 32 seccomp.32
$fsec_optimize seccomp.32

# seccomp.block_secondary
$fseccomp secondary block seccomp.block_secondary

# seccomp.mdwx
$fseccomp memory-deny-write-execute seccomp.mdwx

# seccomp.mdwx.32
$fseccomp memory-deny-write-execute.32 seccomp.mdwx.32
