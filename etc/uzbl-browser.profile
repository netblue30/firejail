# Firejail profile for uzbl-browser

noblacklist ~/.config/uzbl
noblacklist ~/.cache/uzbl
noblacklist ~/.gnupg
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

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

mkdir ~/.gnupg
whitelist ~/.gnupg
mkdir ~/.password-store
whitelist ~/.password-store

include /etc/firejail/whitelist-common.inc
