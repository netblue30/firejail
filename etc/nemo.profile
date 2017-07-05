# Persistent global definitions go here
include /etc/firejail/globals.local

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
no3d
nonewprivs
noroot
nosound
novideo
protocol unix,inet,inet6
seccomp
shell none

noexec ${HOME}
noexec /tmp
