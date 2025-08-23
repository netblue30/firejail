# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include whitelist-runuser-common.local

# common ${RUNUSER} (=/run/user/$UID) whitelist for all profiles

whitelist ${RUNUSER}/bus
whitelist ${RUNUSER}/dconf
whitelist ${RUNUSER}/gdm/Xauthority
whitelist ${RUNUSER}/ICEauthority
whitelist ${RUNUSER}/.mutter-Xwaylandauth.*
whitelist ${RUNUSER}/pulse/native
whitelist ${RUNUSER}/pipewire-*
whitelist ${RUNUSER}/wayland-*
whitelist ${RUNUSER}/xauth_*
whitelist ${RUNUSER}/[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]-[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]-[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]-[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]-[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]

# wayland and pipewire files I've seen so far (Debian 13):
#/run/user/1000/wayland-0.lock
#/run/user/1000/wayland-0
#/run/user/1000/pipewire-0
#/run/user/1000/pipewire-0-manager
#/run/user/1000/pipewire-0.lock
#/run/user/1000/pipewire-0-manager.lock
