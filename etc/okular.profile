# Firejail profile for okular
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/okular.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/okularpartrc
noblacklist ~/.config/okularrc
noblacklist ~/.kde/share/apps/okular
noblacklist ~/.kde/share/config/okularpartrc
noblacklist ~/.kde/share/config/okularrc
noblacklist ~/.kde4/share/apps/okular
noblacklist ~/.kde4/share/config/okularpartrc
noblacklist ~/.kde4/share/config/okularrc
noblacklist ~/.local/share/okular

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
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

# private-bin okular,kbuildsycoca4,lpr
private-dev
# private-etc fonts,X11
private-tmp

noexec ${HOME}
noexec /tmp
