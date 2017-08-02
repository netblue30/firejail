# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/skype.local

# Skype profile
noblacklist ${HOME}/.Skype

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
shell none

private-dev
private-tmp
disable-mnt

noexec ${HOME}
noexec /tmp
