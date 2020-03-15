# Local customizations come here
include whitelist-runuser-common.local

# common ${RUNUSER} (=/run/user/$UID) whitelist for all profiles

whitelist ${RUNUSER}/bus
whitelist ${RUNUSER}/gdm/Xauthority
whitelist ${RUNUSER}/pulse
whitelist ${RUNUSER}/wayland-0
