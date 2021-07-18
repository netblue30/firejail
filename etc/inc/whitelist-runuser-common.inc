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
whitelist ${RUNUSER}/wayland-0
whitelist ${RUNUSER}/wayland-1
whitelist ${RUNUSER}/xauth_*
whitelist ${RUNUSER}/[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]-[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]-[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]-[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]-[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]
