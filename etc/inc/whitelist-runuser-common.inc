# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include whitelist-runuser-common.local

# common ${RUNUSER} (=/run/user/$UID) whitelist for all profiles

allow  ${RUNUSER}/bus
allow  ${RUNUSER}/dconf
allow  ${RUNUSER}/gdm/Xauthority
allow  ${RUNUSER}/ICEauthority
allow  ${RUNUSER}/.mutter-Xwaylandauth.*
allow  ${RUNUSER}/pulse/native
allow  ${RUNUSER}/wayland-0
allow  ${RUNUSER}/wayland-1
allow  ${RUNUSER}/xauth_*
allow  ${RUNUSER}/[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]-[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]-[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]-[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]-[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]
