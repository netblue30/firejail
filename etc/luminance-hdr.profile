# luminance-hdr
noblacklist ${HOME}/.config/Luminance
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
ipc-namespace
netfilter
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
shell none
tracelog

noexec ${HOME}
noexec /tmp

private-tmp
private-dev
