# luminance-hdr
noblacklist ${HOME}/.config/Luminance
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-devel.inc


caps.drop all
netfilter
protocol unix
nonewprivs
noroot
seccomp
shell none
tracelog
private-tmp
private-dev
noexec ${HOME}
noexec /tmp
nogroups
nosound
ipc-namespace
