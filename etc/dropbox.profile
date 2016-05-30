# dropbox profile
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
