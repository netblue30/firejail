# gpg profile
noblacklist ~/.gnupg

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
nogroups
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp
netfilter
no3d
shell none
tracelog

blacklist /tmp/.X11-unix

# private-bin gpg,gpg-agent
private-dev
