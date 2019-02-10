# Firejail profile for snap
# Description: generic Ubuntu snap application profile
# This file is overwritten after every install/update
# Persistent local customizations
include snap.local
# Persistent global definitions
include globals.local

# Generic Ubuntu snap application profile

include disable-common.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist ${DOWNLOADS}
whitelist ${HOME}/snap
include whitelist-common.inc
