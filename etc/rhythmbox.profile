# Firejail profile for rhythmbox
# Description: Music player and organizer for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include rhythmbox.local
# Persistent global definitions
include globals.local

noblacklist ${MUSIC}
noblacklist ${HOME}/.local/share/rhythmbox

include disable-common.inc
include disable-devel.inc
# rhythmbox is using Python
include disable-exec.inc
#include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

# apparmor - makes settings immutable
caps.drop all
netfilter
# no3d
# nodbus - makes settings immutable
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin rhythmbox
private-dev
private-tmp

