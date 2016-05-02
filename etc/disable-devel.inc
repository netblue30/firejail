# development tools

# GCC
blacklist /usr/include
blacklist /usr/bin/gcc*
blacklist /usr/bin/cpp*
blacklist /usr/bin/c9*
blacklist /usr/bin/c8*
blacklist /usr/bin/c++*
blacklist /usr/bin/ld
blacklist /usr/bin/gdb
blacklist /usr/bin/g++*
blacklist /usr/bin/x86_64-linux-gnu-g++*

# clang/llvm
blacklist /usr/bin/clang*
blacklist /usr/bin/llvm*
blacklist /usb/bin/lldb*
blacklist /usr/lib/llvm*

# Valgrind
blacklist /usr/bin/valgrind*
blacklist /usr/lib/valgrind

# Perl
blacklist /usr/bin/perl
blacklist /usr/bin/cpan*
blacklist /usr/share/perl*
blacklist /usr/lib/perl*

# PHP
blacklist /usr/bin/php*
blacklist /usr/share/php*
blacklist /usr/lib/php*

# Ruby
blacklist /usr/bin/ruby
blacklist /usr/lib/ruby

# disabled temporarily pending globbing implementation
# in noblacklist command and firefox profile fix
# Python 2
#blacklist /usr/bin/python2*
#blacklist /usr/lib/python2*
#blacklist /usr/local/lib/python2*
#blacklist /usr/include/python2*
#blacklist /usr/share/python2*
#
# Python 3
#blacklist /usr/bin/python3*
#blacklist /usr/lib/python3*
#blacklist /usr/local/lib/python3*
#blacklist /usr/share/python3*
#blacklist /usr/include/python3*

