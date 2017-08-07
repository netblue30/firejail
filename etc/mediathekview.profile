# Firejail profile for mediathekview
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/mediathekview.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/vlc
noblacklist ~/.mediathek3

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
tracelog

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
