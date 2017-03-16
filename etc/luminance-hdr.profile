# luminance-hdr
noblacklist ${HOME}/.config/Luminance
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
protocol unix
nonewprivs
noroot
seccomp
shell none
tracelog
#private-tmp - mask KDE problems
private-dev
noexec ${HOME}
noexec /tmp
nogroups
nosound
ipc-namespace
