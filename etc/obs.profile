# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/obs.local

# Firejail profile for OBS Studio
noblacklist ${HOME}/.config/obs-studio

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
nogroups
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
