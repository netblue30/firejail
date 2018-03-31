# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/disable-devel.local

# development tools

# GCC
#blacklist /usr/lib/gcc	- seems to create problems on Gentoo
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
blacklist /usr/include

# clang/llvm
blacklist ${PATH}/clang*
blacklist ${PATH}/lldb*
blacklist ${PATH}/llvm*
blacklist /usr/lib/llvm*

# tcc - Tiny C Compiler
blacklist ${PATH}/tcc
blacklist ${PATH}/x86_64-tcc
blacklist /usr/lib/tcc

# Valgrind
blacklist ${PATH}/valgrind*
blacklist /usr/lib/valgrind

# Java
blacklist ${PATH}/java
blacklist ${PATH}/javac
blacklist /usr/lib/java
blacklist /etc/java
blacklist /usr/share/java

#Go
blacklist ${PATH}/gccgo
blacklist ${PATH}/go
blacklist ${PATH}/gofmt

#Rust
blacklist ${PATH}/rust-gdb
blacklist ${PATH}/rust-lldb
blacklist ${PATH}/rustc

#OpenSSL
blacklist ${PATH}/openssl
blacklist ${PATH}/openssl-1.0
