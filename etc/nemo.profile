# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/nemo.local

noblacklist ${HOME}/.config/nemo
noblacklist ${HOME}/.local/share/nemo
noblacklist ${HOME}/.local/share/nemo-python
noblacklist ${HOME}/.local/share/Trash

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6
seccomp

#
# depending on your usage, you can enable some of the commands below: 
#
nogroups
shell none
# private-bin program
# private-etc none
# private-dev
# private-tmp
# nosound
