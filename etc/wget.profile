quiet
# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/wget.local

# wget profile
noblacklist ~/.wgetrc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
#ipc-namespace
netfilter
no3d
nogroups
nonewprivs
noroot
nosound
novideo
protocol unix,inet,inet6
seccomp
shell none

blacklist /tmp/.X11-unix

# private-bin wget
private-dev
# private-etc resolv.conf
# private-tmp

read-write /var/lib/rkhunter/tmp
noexec ${HOME}
noexec /tmp
