# Firejail profile for dropbox
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/dropbox.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/autostart
noblacklist ~/.dropbox-dist

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.dropbox
mkdir ~/.dropbox-dist
mkdir ~/Dropbox
mkfile ~/.config/autostart/dropbox.desktop
whitelist ~/.config/autostart/dropbox.desktop
whitelist ~/.dropbox
whitelist ~/.dropbox-dist
whitelist ~/Dropbox
include /etc/firejail/whitelist-common.inc

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

private-dev
private-tmp

noexec /tmp
