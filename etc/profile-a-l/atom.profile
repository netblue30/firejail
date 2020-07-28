# Firejail profile for atom
# Description: A hackable text editor for the 21st Century
# This file is overwritten after every install/update
# Persistent local customizations
include atom.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.atom
noblacklist ${HOME}/.config/Atom

# Allows files commonly used by IDEs
include allow-common-devel.inc

include disable-common.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.keep sys_admin,sys_chroot
# net none
netfilter
nodvd
nogroups
nosound
notv
nou2f
novideo
shell none

private-cache
private-dev
private-tmp

dbus-user none
dbus-system none
