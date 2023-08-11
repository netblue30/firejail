# Firejail profile for gedit
# Description: Official text editor of the GNOME desktop environment
# This file is overwritten after every install/update
# Persistent local customizations
include gedit.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/enchant
noblacklist ${HOME}/.config/gedit

# Allows files commonly used by IDEs
include allow-common-devel.inc

include disable-common.inc
#include disable-devel.inc
include disable-exec.inc
#include disable-interpreters.inc
include disable-programs.inc

include whitelist-runuser-common.inc
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
seccomp.block-secondary
tracelog

#private-bin gedit
private-dev
# private-lib breaks python plugins - add the next line to your gedit.local if you don't use them.
#private-lib aspell,gconv,gedit,libgspell-1.so.*,libgtksourceview-*,libpeas-gtk-1.0.so.*,libreadline.so.*,libtinfo.so.*
private-tmp

# makes settings immutable
#dbus-user none
#dbus-system none

restrict-namespaces
