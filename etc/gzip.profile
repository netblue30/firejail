################################
# Gzip profile 
################################
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

blacklist ${HOME}/.wine
blacklist ${HOME}/.ssh

tracelog
caps.drop all
seccomp 
net none
noroot
nosound
nogroups
nonewprivs

