# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/arduino.local

# Firejail profile for arduino
noblacklist ${HOME}/.arduino15
noblacklist ${HOME}/Arduino

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
no3d
nogroups
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp
shell none

private-tmp

noexec ${HOME}
noexec /tmp
