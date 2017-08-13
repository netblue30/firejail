# Firejail profile for midori
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/midori.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/midori
noblacklist ~/.local/share/midori
noblacklist ~/.local/share/webkit
noblacklist ~/.local/share/webkitgtk
noblacklist ~/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.cache/midori
mkdir ~/.config/midori
mkdir ~/.local/share/midori
mkdir ~/.local/share/webkit
mkdir ~/.local/share/webkitgtk
mkdir ~/.pki
whitelist ${DOWNLOADS}
whitelist ~/.cache/gnome-mplayer/plugin
whitelist ~/.cache/midori
whitelist ~/.config/gnome-mplayer
whitelist ~/.config/midori
whitelist ~/.lastpass
whitelist ~/.local/share/midori
whitelist ~/.local/share/webkit
whitelist ~/.local/share/webkitgtk
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
# noroot - problems on Ubuntu 14.04
notv
protocol unix,inet,inet6,netlink
seccomp
tracelog
