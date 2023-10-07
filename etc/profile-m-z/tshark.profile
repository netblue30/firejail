# Firejail profile for tshark
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include tshark.local
# Persistent global definitions
# added by included profile
#include globals.local

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}

# Redirect
include wireshark.profile
