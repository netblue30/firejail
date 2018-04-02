# Firejail profile for tracker
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/tracker.local
# Persistent global definitions
include /etc/firejail/globals.local

# Tracker is started by systemd on most systems. Therefore it is not firejailed by default

blacklist /tmp/.X11-unix

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
no3d
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
tracelog

# private-bin tracker
# private-dev
# private-etc fonts
# private-tmp
