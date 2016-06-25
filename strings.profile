noblacklist ~/.config

include /usr/local/etc/firejail/disable-common.inc
include /usr/local/etc/firejail/disable-programs.inc
include /usr/local/etc/firejail/disable-devel.inc
include /usr/local/etc/firejail/disable-passwdmgr.inc

caps.drop all
noroot
nonewprivs
seccomp
tracelog
