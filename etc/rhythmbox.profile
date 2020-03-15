# Firejail profile for rhythmbox
# Description: Music player and organizer for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include rhythmbox.local
# Persistent global definitions
include globals.local

noblacklist ${MUSIC}
noblacklist ${HOME}/.cache/rhythmbox
noblacklist ${HOME}/.local/share/rhythmbox

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/rhythmbox
whitelist /usr/share/lua
whitelist /usr/share/libquvi-scripts
include whitelist-usr-share-common.inc
include whitelist-runuser-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
# nodbus - makes settings immutable
nogroups
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

private-bin rhythmbox,rhythmbox-client
private-dev
private-tmp
