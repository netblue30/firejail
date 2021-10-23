# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include whitelist-run-common.local

whitelist /run/NetworkManager/resolv.conf
whitelist /run/cups/cups.sock
whitelist /run/dbus/system_bus_socket
whitelist /run/media
whitelist /run/resolvconf/resolv.conf
whitelist /run/shm
whitelist /run/systemd/journal/dev-log
whitelist /run/systemd/journal/socket
whitelist /run/systemd/resolve/resolv.conf
whitelist /run/systemd/resolve/stub-resolv.conf
whitelist /run/udev/data
