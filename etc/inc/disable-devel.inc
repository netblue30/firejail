# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include disable-devel.local

# development tools

# clang/llvm
blacklist ${PATH}/clang*
blacklist ${PATH}/lldb*
blacklist ${PATH}/llvm*
# see issue #2106 - it disables hardware acceleration in Firefox on Radeon GPU
# blacklist /usr/lib/llvm*

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
