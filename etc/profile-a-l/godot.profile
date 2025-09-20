# Firejail profile for godot
# Description: multi-platform 2D and 3D game engine with a feature-rich editor
# This file is overwritten after every install/update
# Persistent local customizations
include godot.local
# Persistent global definitions
include globals.local

# Needed for loading addons
ignore noexec ${HOME}

noblacklist ${HOME}/.cache/godot
noblacklist ${HOME}/.config/godot
noblacklist ${HOME}/.local/share/godot
noblacklist ${HOME}/.local/share/Trash

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
#noinput # breaks gamepads (see #6707)
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
tracelog

#private-bin godot
private-cache
private-dev
private-etc @games,@tls-ca,@x11,mono
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
