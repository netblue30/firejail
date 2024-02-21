# Firejail profile for gnome-latex
# Description: LaTeX editor for the GNOME desktop
# This file is overwritten after every install/update
# Persistent local customizations
include gnome-latex.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/gnome-latex
noblacklist ${HOME}/.local/share/gnome-latex

# Allow perl (blacklisted by disable-interpreters.inc)
include allow-perl.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

whitelist /usr/share/gnome-latex
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
# May cause issues.
#include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
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
protocol unix
seccomp
seccomp.block-secondary
tracelog

private-cache
private-dev
# passwd,login.defs,firejail are a temporary workaround for #2877 and can be removed once it is fixed
private-etc @x11,latexmk.conf,texlive

dbus-system none

restrict-namespaces
