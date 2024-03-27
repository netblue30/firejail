# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include disable-x11.local

blacklist /tmp/.X11-unix
blacklist ${HOME}/.Xauthority
blacklist ${RUNUSER}/gdm/Xauthority
blacklist ${RUNUSER}/.mutter-Xwaylandauth*
blacklist ${RUNUSER}/xauth_*
#blacklist ${RUNUSER}/[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]-[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]-[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]-[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]-[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]]
blacklist /tmp/xauth*
blacklist /tmp/.ICE-unix
blacklist ${RUNUSER}/ICEauthority
rmenv DISPLAY
rmenv XAUTHORITY
