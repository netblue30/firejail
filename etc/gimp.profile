# Firejail profile for gimp
# Description: GNU Image Manipulation Program
# This file is overwritten after every install/update
# Persistent local customizations
include gimp.local
# Persistent global definitions
include globals.local

# gimp plugins are installed by the user in ${HOME}/.gimp-2.8/plug-ins/ directory
# if you are not using external plugins, you can comment 'ignore noexec' statement below
# or put 'noexec ${HOME}' in your gimp.local
ignore noexec ${HOME}

noblacklist ${HOME}/.cache/gimp
noblacklist ${HOME}/.config/GIMP
noblacklist ${HOME}/.gimp*
noblacklist ${DOCUMENTS}
noblacklist ${PICTURES}

include disable-common.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/gimp
whitelist /usr/share/mypaint-data
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

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
nou2f
protocol unix
seccomp
shell none

private-dev
private-tmp
