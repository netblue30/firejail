# transmission-show profile
noblacklist ${HOME}/.config/transmission
noblacklist ${HOME}/.cache/transmission

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
net none
nonewprivs
noroot
nosound
protocol unix
seccomp
shell none
tracelog

# private-bin
private-tmp
private-dev
private-etc none
