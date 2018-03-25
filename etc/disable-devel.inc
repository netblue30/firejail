# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/disable-devel.local

# development tools

# GCC
#blacklist /usr/lib/gcc	- seems to create problems on Gentoo
blacklist ${PATH}/as
blacklist ${PATH}/c++*
blacklist ${PATH}/c8*
blacklist ${PATH}/c9*
blacklist ${PATH}/cpp*
blacklist ${PATH}/g++*
blacklist ${PATH}/gcc*
blacklist ${PATH}/gdb
blacklist ${PATH}/ld
blacklist ${PATH}/x86_64-unknown-linux-gnu-gcc*
blacklist ${PATH}/x86_64-linux-gnu-g++*
blacklist ${PATH}/x86_64-linux-gnu-gcc*
blacklist ${PATH}/x86_64-unknown-linux-gnu-g++*
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

# Perl
blacklist ${PATH}/cpan*
blacklist ${PATH}/perl
blacklist /usr/lib/perl*
blacklist /usr/share/perl*

# PHP
blacklist ${PATH}/php*
blacklist /usr/lib/php*
blacklist /usr/share/php*

# Ruby
blacklist ${PATH}/ruby
blacklist /usr/lib/ruby

# Programs using python: deluge, firefox addons, filezilla, cherrytree, xchat, hexchat, libreoffice, scribus
# Python 2
#blacklist ${PATH}/python2*
#blacklist /usr/include/python2*
#blacklist /usr/lib/python2*
#blacklist /usr/local/lib/python2*
#blacklist /usr/share/python2*
#
# Python 3
#blacklist ${PATH}/python3*
#blacklist /usr/include/python3*
#blacklist /usr/lib/python3*
#blacklist /usr/local/lib/python3*
#blacklist /usr/share/python3*

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
