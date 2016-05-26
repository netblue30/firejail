# Firejail profile for Qutebrowser (Qt5-Webkit+Python) browser

noblacklist ~/.config/qutebrowser
noblacklist ~/.cache/qutebrowser
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
seccomp
protocol unix,inet,inet6,netlink
netfilter
tracelog
nonewprivs
noroot

whitelist ${DOWNLOADS}
mkdir ~/.config/qutebrowser
whitelist ~/.config/qutebrowser
mkdir ~/.cache
mkdir ~/.cache/qutebrowser
whitelist ~/.cache/qutebrowser
include /etc/firejail/whitelist-common.inc
