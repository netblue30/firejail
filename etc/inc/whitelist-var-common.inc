# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include whitelist-var-common.local

# common /var whitelist for all profiles

allow  /var/lib/aspell
allow  /var/lib/ca-certificates
allow  /var/lib/dbus
allow  /var/lib/menu-xdg
allow  /var/lib/uim
allow  /var/cache/fontconfig
allow  /var/tmp
allow  /var/run
allow  /var/lock
