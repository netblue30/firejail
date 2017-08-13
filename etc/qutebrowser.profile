# Firejail profile for qutebrowser
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/qutebrowser.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.cache/qutebrowser
noblacklist ~/.config/qutebrowser

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.cache/qutebrowser
mkdir ~/.config/qutebrowser
mkdir ~/.local/share/qutebrowser
whitelist ${DOWNLOADS}
whitelist ~/.cache/qutebrowser
whitelist ~/.config/qutebrowser
whitelist ~/.local/share/qutebrowser
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
tracelog
