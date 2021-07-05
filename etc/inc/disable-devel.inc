# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include disable-devel.local

# development tools

# clang/llvm
deny  ${PATH}/clang*
deny  ${PATH}/lldb*
deny  ${PATH}/llvm*
# see issue #2106 - it disables hardware acceleration in Firefox on Radeon GPU
# blacklist /usr/lib/llvm*

# GCC
deny  ${PATH}/as
deny  ${PATH}/cc
deny  ${PATH}/c++*
deny  ${PATH}/c8*
deny  ${PATH}/c9*
deny  ${PATH}/cpp*
deny  ${PATH}/g++*
deny  ${PATH}/gcc*
deny  ${PATH}/gdb
deny  ${PATH}/ld
deny  ${PATH}/*-gcc*
deny  ${PATH}/*-g++*
deny  ${PATH}/*-gcc*
deny  ${PATH}/*-g++*
# seems to create problems on Gentoo
#blacklist /usr/lib/gcc

#Go
deny  ${PATH}/gccgo
deny  ${PATH}/go
deny  ${PATH}/gofmt

# Java
deny  ${PATH}/java
deny  ${PATH}/javac
deny  /etc/java
deny  /usr/lib/java
deny  /usr/share/java

#OpenSSL
deny  ${PATH}/openssl
deny  ${PATH}/openssl-1.0

#Rust
deny  ${PATH}/rust-gdb
deny  ${PATH}/rust-lldb
deny  ${PATH}/rustc
deny  ${HOME}/.rustup

# tcc - Tiny C Compiler
deny  ${PATH}/tcc
deny  ${PATH}/x86_64-tcc
deny  /usr/lib/tcc

# Valgrind
deny  ${PATH}/valgrind*
deny  /usr/lib/valgrind


# Source-Code

deny  /usr/src
deny  /usr/local/src
deny  /usr/include
deny  /usr/local/include
