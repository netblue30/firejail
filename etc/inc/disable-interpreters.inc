# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include disable-interpreters.local

# gjs
blacklist ${PATH}/gjs
blacklist ${PATH}/gjs-console
blacklist /usr/lib/gjs
blacklist /usr/lib/libgjs*
blacklist /usr/lib64/gjs
blacklist /usr/lib64/libgjs*

# Lua
blacklist ${PATH}/lua*
blacklist /usr/include/lua*
blacklist /usr/lib/liblua*
blacklist /usr/lib/lua
blacklist /usr/lib64/liblua*
blacklist /usr/lib64/lua
blacklist /usr/share/lua*

# mozjs
blacklist /usr/lib/libmozjs-*
blacklist /usr/lib64/libmozjs-*

# Node.js
blacklist ${PATH}/node
blacklist /usr/include/node

# nvm
blacklist ${HOME}/.nvm

# Perl
blacklist ${PATH}/core_perl
blacklist ${PATH}/cpan*
blacklist ${PATH}/perl
blacklist ${PATH}/site_perl
blacklist ${PATH}/vendor_perl
blacklist /usr/lib/perl*
blacklist /usr/lib64/perl*
blacklist /usr/share/perl*

# PHP
blacklist ${PATH}/php*
blacklist /usr/lib/php*
blacklist /usr/share/php*

# Ruby
blacklist ${PATH}/ruby
blacklist /usr/lib/ruby
blacklist /usr/lib64/ruby

# Programs using python: deluge, firefox addons, filezilla, cherrytree, xchat, hexchat, libreoffice, scribus
# Python 2
blacklist ${PATH}/python2*
blacklist /usr/include/python2*
blacklist /usr/lib/python2*
blacklist /usr/local/lib/python2*
blacklist /usr/share/python2*

# You will want to add noblacklist for python3 stuff in the firefox and/or chromium profiles if you use the Gnome connector (see Issue #2026)

# Python 3
blacklist ${PATH}/python3*
blacklist /usr/include/python3*
blacklist /usr/lib/python3*
blacklist /usr/lib64/python3*
blacklist /usr/local/lib/python3*
blacklist /usr/share/python3*
