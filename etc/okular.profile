# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/okular.local

# KDE okular profile
noblacklist ~/.kde4/share/apps/okular
noblacklist ~/.kde4/share/config/okularrc
noblacklist ~/.kde4/share/config/okularpartrc
noblacklist ~/.kde/share/apps/okular
noblacklist ~/.kde/share/config/okularrc
noblacklist ~/.kde/share/config/okularpartrc
noblacklist ~/.local/share/okular
noblacklist ~/.config/okularrc
noblacklist ~/.config/okularpartrc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
nogroups
noroot
nosound
protocol unix
seccomp
shell none
tracelog

# private-bin okular,kbuildsycoca4,lpr
# private-etc fonts,X11
private-dev
private-tmp
