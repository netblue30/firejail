# Firejail profile for geeqie
# Description: Image viewer using GTK+
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/geeqie.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/geeqie
noblacklist ${HOME}/.config/geeqie
noblacklist ${HOME}/.local/share/geeqie

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none

# private-bin geeqie
private-dev
# private-etc X11
