# Firejail profile for irssi
# Description: TUI IRC client
# This file is overwritten after every install/update
# Persistent local customizations
include irssi.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.irssi

# Add the next line to irssi.local if you use perl scripting.
#include allow-perl.inc

blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-proc.inc
include disable-programs.inc
include disable-shell.inc
include disable-X11.inc
include disable-xdg.inc

mkdir ${HOME}/.irssi
whitelist ${HOME}/.irssi
include whitelist-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noprinters
noroot
nosound
notpm
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary

disable-mnt
private-cache
private-dev
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
