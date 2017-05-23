# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/midori.local

# Midori profile
noblacklist ~/.config/midori
noblacklist ~/.local/share/midori
noblacklist ~/.local/share/webkit
noblacklist ~/.local/share/webkitgtk
noblacklist ~/.pki
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

mkdir ~/.config/midori
whitelist ~/.config/midori

mkdir ~/.cache/midori
whitelist ~/.cache/midori

mkdir ~/.local/share/midori
whitelist ~/.local/share/midori

mkdir ~/.local/share/webkit
whitelist ~/.local/share/webkit

mkdir ~/.local/share/webkitgtk
whitelist ~/.local/share/webkitgtk

whitelist ${DOWNLOADS}
whitelist ~/.config/gnome-mplayer
whitelist ~/.cache/gnome-mplayer/plugin
mkdir ~/.pki
whitelist ~/.pki
whitelist ~/.lastpass


caps.drop all
netfilter
nonewprivs
# noroot - porblems on Ubuntu 14.04
protocol unix,inet,inet6,netlink
seccomp
tracelog


