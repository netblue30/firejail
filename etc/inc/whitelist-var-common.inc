# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include whitelist-var-common.local

# common /var whitelist for all profiles

whitelist /var/lib/aspell
whitelist /var/lib/ca-certificates
whitelist /var/lib/dbus
whitelist /var/lib/menu-xdg
whitelist /var/lib/uim
whitelist /var/cache/fontconfig
whitelist /var/tmp
whitelist /var/run
whitelist /var/lock
