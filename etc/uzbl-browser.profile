# Firejail profile for uzbl-browser

noblacklist ~/.config/uzbl
noblacklist ~/.cache/uzbl
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
tracelog

mkdir ~/.config/uzbl
whitelist ~/.config/uzbl
mkdir ~/.cache/uzbl
whitelist ~/.cache/uzbl
mkdir ~/.local/share/uzbl
whitelist ~/.local/share/uzbl

whitelist ${DOWNLOADS}

include /etc/firejail/whitelist-common.inc
