# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include allow-php.local

nodeny  ${PATH}/php*
nodeny  /usr/lib/php*
nodeny  /usr/share/php*
