# mcabber profile
noblacklist ${HOME}/.mcabber
noblacklist ${HOME}/.mcabberrc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol inet,inet6
seccomp

private-bin mcabber
private-etc null
private-dev
shell none
nosound
