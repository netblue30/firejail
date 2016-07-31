# Firejail profile for Qutebrowser (Qt5-Webkit+Python) browser

noblacklist ~/.config/qutebrowser
noblacklist ~/.cache/qutebrowser
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
mkdir ~/.cache/qutebrowser
whitelist ~/.cache/qutebrowser
include /etc/firejail/whitelist-common.inc
