include /usr/local/etc/firejail/server.profile
include /usr/local/etc/firejail/disable-common.inc
include /usr/local/etc/firejail/disable-programs.inc
include /usr/local/etc/firejail/disable-passwdmgr.inc
caps.drop all
shell none
seccomp
