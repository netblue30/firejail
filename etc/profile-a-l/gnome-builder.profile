# Firejail profile for gnome-builder
# Description: IDE for GNOME
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-builder.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.bash_history

nodeny  ${HOME}/.cache/gnome-builder
nodeny  ${HOME}/.config/gnome-builder
nodeny  ${HOME}/.local/share/gnome-builder

# Allows files commonly used by IDEs
include allow-common-devel.inc

include disable-common.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-runuser-common.inc

caps.drop all
ipc-namespace
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev

read-write ${HOME}/.bash_history
