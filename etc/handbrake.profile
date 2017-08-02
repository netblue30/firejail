# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/handbrake.local

noblacklist ~/.config/ghb
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
