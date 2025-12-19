# Firejail profile for gnome-text-editor
# Description: Simple Gnome text editor
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-text-editor.local
# Persistent global definitions
include globals.local

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc
include whitelist-var-common.inc


apparmor
caps.drop all
net none
nodvd
nogroups
noinput
nonewprivs

# Debian stable: when you try to open an existing file, it activates systemd-hostnamed; noroot seems to disable it
#noroot

nosound
notv
nou2f
novideo
protocol unix
seccomp
tracelog

private-bin gnome-text-editor,bash,dash,sh
private-dev
private-lib
private-tmp

restrict-namespaces
