# qpdfview profile
noblacklist ${HOME}/.config/qpdfview
noblacklist ${HOME}/.local/share/qpdfview

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
shell none
tracelog

private-bin qpdfview
private-dev
private-tmp
