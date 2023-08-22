# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include disable-devel.local

# development tools

# autoconf/automake
blacklist ${PATH}/autoconf
blacklist ${PATH}/autoheader
blacklist ${PATH}/autom4te
blacklist ${PATH}/autoreconf
blacklist ${PATH}/autoscan
blacklist ${PATH}/autoupdate
blacklist ${PATH}/ifnames
blacklist ${PATH}/aclocal*
blacklist ${PATH}/automake*
blacklist ${PATH}/dh_*
blacklist ${PATH}/m4

# patch
blacklist ${PATH}/patch
blacklist ${PATH}/patchview
blacklist ${PATH}/espdiff
blacklist ${PATH}/elfedit

# expect
blacklist ${PATH}/expect*
blacklist ${PATH}/autoexpect

# clang/llvm
blacklist ${PATH}/clang*
blacklist ${PATH}/lldb*
blacklist ${PATH}/llvm*
# see issue #2106 - it disables hardware acceleration in Firefox on Radeon GPU
# blacklist /usr/lib/llvm*
blacklist ${PATH}/scan-build
blacklist ${PATH}/analyze-build*
blacklist ${PATH}/asan_symbolize*
blacklist ${PATH}/bugpoint*
blacklist ${PATH}/c-index-test*
blacklist ${PATH}/llc*
blacklist ${PATH}/lli*

# GCC
blacklist ${PATH}/as
blacklist ${PATH}/cc
blacklist ${PATH}/c++*
blacklist ${PATH}/c8*
blacklist ${PATH}/c9*
blacklist ${PATH}/cpp*
blacklist ${PATH}/g++*
blacklist ${PATH}/gcc*
blacklist ${PATH}/gdb
blacklist ${PATH}/ld
blacklist ${PATH}/*-gcc*
blacklist ${PATH}/*-g++*
blacklist ${PATH}/*-gcc*
blacklist ${PATH}/*-g++*
# seems to create problems on Gentoo
#blacklist /usr/lib/gcc
blacklist ${PATH}/elfedit
blacklist ${PATH}/gcov*
blacklist ${PATH}/gmake
blacklist ${PATH}/make
blacklist ${PATH}/make-first-existing-target
blacklist ${PATH}/x86_64-linux-gnu-*

#Go
blacklist ${PATH}/gccgo
blacklist ${PATH}/go
blacklist ${PATH}/gofmt

# Java
blacklist ${PATH}/java
blacklist ${PATH}/javac
blacklist /etc/java
blacklist /usr/lib/java
blacklist /usr/share/java

# Scala
blacklist ${PATH}/scala
blacklist ${PATH}/scala3
blacklist ${PATH}/scala3-compiler
blacklist ${PATH}/scala3-repl
blacklist ${PATH}/scalac

#OpenSSL
blacklist ${PATH}/openssl
blacklist ${PATH}/openssl-1.0

#Rust
blacklist ${PATH}/rust-gdb
blacklist ${PATH}/rust-lldb
blacklist ${PATH}/rustc
blacklist ${HOME}/.rustup

# tcc - Tiny C Compiler
blacklist ${PATH}/tcc
blacklist ${PATH}/x86_64-tcc
blacklist /usr/lib/tcc

# Valgrind
blacklist ${PATH}/valgrind*
blacklist /usr/lib/valgrind

# Source-Code
blacklist /usr/src
blacklist /usr/local/src
blacklist /usr/include
blacklist /usr/local/include
