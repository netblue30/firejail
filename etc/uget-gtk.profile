# Firejail profile for uget-gtk
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/uget-gtk.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/uGet

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.config/uGet
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/uGet
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

private-bin uget-gtk
private-dev
private-tmp
