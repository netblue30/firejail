# Firejail profile for gimp
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gimp.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.gimp*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
net none
nodvd
nogroups
nonewprivs
noroot
nosound
notv
protocol unix
seccomp
shell none

private-dev
private-tmp

# gimp plugins are installed by the user in ~/.gimp-2.8/plug-ins/ directory
# if you are not using external plugins, you can enable noexec statement below
# noexec ${HOME}
noexec /tmp
