# mcabber profile
noblacklist ${HOME}/.mcabber
noblacklist ${HOME}/.mcabberrc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
seccomp
protocol inet,inet6
netfilter
nonewprivs
noroot

private-bin mcabber
private-etc null
private-dev
shell none
