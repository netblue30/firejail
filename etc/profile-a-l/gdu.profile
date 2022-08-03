# Firejail profile for gdu
# Description: Fast disk usage analyzer with console interface
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include gdu.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

include disable-exec.inc

caps.drop all
ipc-namespace
net none
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
seccomp
seccomp.block-secondary
x11 none

private-dev

dbus-user none
dbus-system none

memory-deny-write-execute

# gdu has built-in delete (d), empty (e) dir/file support and shell spawning (b) features.
# To harden the sandbox we cripple those here.
# Add ignore statements in your gdu.local if you need/want these functionalities.
include disable-shell.inc
private-bin gdu
read-only ${HOME}
