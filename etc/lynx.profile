# Firejail profile for lynx
# Description: Classic non-graphical (text-mode) web browser
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/lynx.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /tmp/.X11-unix

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

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
protocol unix,inet,inet6
seccomp
shell none
tracelog

# private-bin lynx
private-cache
private-dev
# private-etc ca-certificates,ssl,pki,crypto-policies
private-tmp
