# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/qutebrowser.local

# Firejail profile for Qutebrowser (Qt5-Webkit+Python) browser
noblacklist ~/.config/qutebrowser
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
tracelog

whitelist ${DOWNLOADS}
mkdir ~/.config/qutebrowser
whitelist ~/.config/qutebrowser
mkdir ~/.local/share/qutebrowser
whitelist ~/.local/share/qutebrowser
include /etc/firejail/whitelist-common.inc
