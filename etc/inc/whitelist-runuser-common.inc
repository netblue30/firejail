# Local customizations come here
include whitelist-runuser-common.local

# common ${RUNUSER} (=/run/user/$UID) whitelist for all profiles

whitelist ${RUNUSER}/bus
whitelist ${RUNUSER}/dconf
whitelist ${RUNUSER}/gdm/Xauthority
whitelist ${RUNUSER}/ICEauthority
whitelist ${RUNUSER}/.mutter-Xwaylandauth.*
whitelist ${RUNUSER}/pulse/native
whitelist ${RUNUSER}/wayland-0
