# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/snap.local

################################
# Generic Ubuntu snap application profile
################################
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

whitelist ~/snap
whitelist ${DOWNLOADS}
include /etc/firejail/whitelist-common.inc
