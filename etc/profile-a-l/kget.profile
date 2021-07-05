# Firejail profile for kget
# Description: Download manager
# This file is overwritten after every install/update
# Persistent local customizations
include kget.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/kgetrc
nodeny  ${HOME}/.kde/share/apps/kget
nodeny  ${HOME}/.kde/share/config/kgetrc
nodeny  ${HOME}/.kde4/share/apps/kget
nodeny  ${HOME}/.kde4/share/config/kgetrc
nodeny  ${HOME}/.local/share/kget
nodeny  ${HOME}/.local/share/kxmlgui5/kget

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp

private-dev
private-tmp

# memory-deny-write-execute
