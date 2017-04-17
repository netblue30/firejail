# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/gimp.local

# gimp
noblacklist ${HOME}/.gimp*
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
ipc-namespace
netfilter
net none
nogroups
nonewprivs
noroot
nosound
protocol unix
seccomp
shell none

# gimp plugins are installed by the user in ~/.gimp-2.8/plug-ins/ directory
# if you are not using external plugins, you can enable noexec statement below
# noexec ${HOME}

noexec /tmp

private-dev
private-tmp
