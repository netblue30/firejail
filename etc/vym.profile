# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/vym.local

noblacklist ./.config/InSilmaril
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
noroot
# no network connectivity
protocol unix
seccomp

#
# depending on your usage, you can enable some of the commands below:
#
nogroups
shell none
# private-bin vym
# private-etc none
private-dev
private-tmp
nosound
