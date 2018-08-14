# Firejail profile for gimp
# Description: GNU Image Manipulation Program
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gimp.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/GIMP
noblacklist ${HOME}/.gimp*
noblacklist ${DOCUMENTS}
noblacklist ${PICTURES}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

apparmor
caps.drop all
net none
nodbus
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

# gimp plugins are installed by the user in ${HOME}/.gimp-2.8/plug-ins/ directory
# if you are not using external plugins, you can enable noexec statement below
# noexec ${HOME}
noexec /tmp
