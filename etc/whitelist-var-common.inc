# Local customizations come here
include /etc/firejail/whitelist-var-common.local

# common /var whitelist for all profiles

#whitelist /var/lib/dbus/machine-id - problems on Xubuntu, it is a symlink to /etc/machine-id, whitelist will fail
whitelist /var/lib/menu-xdg
whitelist /var/cache/fontconfig
whitelist /var/tmp
whitelist /var/run
