# Firejail profile for snap
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/snap.local
# Persistent global definitions
include /etc/firejail/globals.local

# Generic Ubuntu snap application profile

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${DOWNLOADS}
whitelist ${HOME}/snap
include /etc/firejail/whitelist-common.inc
