# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/transmission-qt.local

# transmission-qt bittorrent profile
noblacklist ${HOME}/.config/transmission
noblacklist ${HOME}/.cache/transmission

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

mkdir ~/.config/transmission
whitelist ~/.config/transmission
mkdir ~/.cache/transmission
whitelist ~/.cache/transmission
whitelist  ${DOWNLOADS}
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nonewprivs
noroot
nosound
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-bin transmission-qt
private-dev
private-tmp
