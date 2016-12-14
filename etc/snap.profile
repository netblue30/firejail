################################
# Generic Ubuntu snap application profile
################################
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

whitelist ~/snap
whitelist ${DOWNLOADS}
include /etc/firejail/whitelist-common.inc


