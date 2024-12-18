# Firejail profile for termshark
# Description: Terminal UI for tshark, inspired by Wireshark
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include termshark.local
# Persistent global definitions
# added by included profile
#include globals.local

blacklist ${RUNUSER}

include disable-x11.inc

# Redirect
include wireshark.profile
