# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/disable-devel.local

# development tools

# GCC
#blacklist /usr/lib/gcc	- seems to create problems on Gentoo
blacklist /usr/bin/as
blacklist /usr/bin/c++*
blacklist /usr/bin/c8*
blacklist /usr/bin/c9*
blacklist /usr/bin/cpp*
blacklist /usr/bin/g++*
blacklist /usr/bin/gcc*
blacklist /usr/bin/gdb
blacklist /usr/bin/ld
blacklist /usr/bin/x86_64-unknown-linux-gnu-gcc*
blacklist /usr/bin/x86_64-linux-gnu-g++*
blacklist /usr/bin/x86_64-linux-gnu-gcc*
blacklist /usr/bin/x86_64-unknown-linux-gnu-g++*
blacklist /usr/include

# clang/llvm
blacklist /usr/bin/clang*
blacklist /usr/bin/lldb*
blacklist /usr/bin/llvm*
blacklist /usr/lib/llvm*

# tcc - Tiny C Compiler
blacklist /usr/bin/tcc
blacklist /usr/bin/x86_64-tcc
blacklist /usr/lib/tcc

# Valgrind
blacklist /usr/bin/valgrind*
blacklist /usr/lib/valgrind

# Perl
blacklist /usr/bin/cpan*
blacklist /usr/bin/perl
blacklist /usr/lib/perl*
blacklist /usr/share/perl*

# PHP
blacklist /usr/bin/php*
blacklist /usr/lib/php*
blacklist /usr/share/php*

# Ruby
blacklist /usr/bin/ruby
blacklist /usr/lib/ruby

# Programs using python: deluge, firefox addons, filezilla, cherrytree, xchat, hexchat, libreoffice, scribus
# Python 2
#blacklist /usr/bin/python2*
#blacklist /usr/include/python2*
#blacklist /usr/lib/python2*
#blacklist /usr/local/lib/python2*
#blacklist /usr/share/python2*
#
# Python 3
#blacklist /usr/bin/python3*
#blacklist /usr/include/python3*
#blacklist /usr/lib/python3*
#blacklist /usr/local/lib/python3*
#blacklist /usr/share/python3*

#Go
blacklist /usr/bin/gccgo
blacklist /usr/bin/go
blacklist /usr/bin/gofmt

#Rust
blacklist /usr/bin/rust-gdb
blacklist /usr/bin/rust-lldb
blacklist /usr/bin/rustc

#OpenSSL
blacklist /usr/bin/openssl
blacklist /usr/bin/openssl-1.0
