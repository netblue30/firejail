# Firejail profile for pix
noblacklist ${HOME}/.config/pix
noblacklist ${HOME}/.local/share/pix

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

private-bin pix
private-dev
private-tmp