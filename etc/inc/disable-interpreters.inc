# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include disable-interpreters.local

# gjs
deny  ${PATH}/gjs
deny  ${PATH}/gjs-console
deny  /usr/lib/gjs
deny  /usr/lib/libgjs*
deny  /usr/lib64/gjs
deny  /usr/lib64/libgjs*

# Lua
deny  ${PATH}/lua*
deny  /usr/include/lua*
deny  /usr/lib/liblua*
deny  /usr/lib/lua
deny  /usr/lib64/liblua*
deny  /usr/lib64/lua
deny  /usr/share/lua*

# mozjs
deny  /usr/lib/libmozjs-*
deny  /usr/lib64/libmozjs-*

# Node.js
deny  ${PATH}/node
deny  /usr/include/node

# nvm
deny  ${HOME}/.nvm

# Perl
deny  ${PATH}/core_perl
deny  ${PATH}/cpan*
deny  ${PATH}/perl
deny  ${PATH}/site_perl
deny  ${PATH}/vendor_perl
deny  /usr/lib/perl*
deny  /usr/lib64/perl*
deny  /usr/share/perl*

# PHP
deny  ${PATH}/php*
deny  /usr/lib/php*
deny  /usr/share/php*

# Ruby
deny  ${PATH}/ruby
deny  /usr/lib/ruby

# Programs using python: deluge, firefox addons, filezilla, cherrytree, xchat, hexchat, libreoffice, scribus
# Python 2
deny  ${PATH}/python2*
deny  /usr/include/python2*
deny  /usr/lib/python2*
deny  /usr/local/lib/python2*
deny  /usr/share/python2*

# You will want to add noblacklist for python3 stuff in the firefox and/or chromium profiles if you use the Gnome connector (see Issue #2026)

# Python 3
deny  ${PATH}/python3*
deny  /usr/include/python3*
deny  /usr/lib/python3*
deny  /usr/lib64/python3*
deny  /usr/local/lib/python3*
deny  /usr/share/python3*
