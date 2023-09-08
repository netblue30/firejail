# Firejail profile for pluma
# Description: Official text editor of the MATE desktop environment
# This file is overwritten after every install/update
# Persistent local customizations
include pluma.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/enchant
noblacklist ${HOME}/.config/pluma

# Allows files commonly used by IDEs
include allow-common-devel.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

include whitelist-var-common.inc

#apparmor # makes settings immutable
caps.drop all
machine-id
#net none # makes settings immutable
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
protocol unix
seccomp
tracelog

private-bin pluma
private-dev
private-lib aspell,gconv,libgspell-1.so.*,libreadline.so.*,libtinfo.so.*,pluma
private-tmp

# makes settings immutable
#dbus-user none
#dbus-system none

restrict-namespaces
join-or-start pluma
