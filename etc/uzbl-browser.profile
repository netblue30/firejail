# Firejail profile for uzbl-browser
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/uzbl-browser.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.config/uzbl
noblacklist ~/.gnupg

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.config/uzbl
mkdir ~/.gnupg
mkdir ~/.local/share/uzbl
mkdir ~/.password-store
whitelist ${DOWNLOADS}
whitelist ~/.config/uzbl
whitelist ~/.gnupg
whitelist ~/.local/share/uzbl
whitelist ~/.password-store
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp
tracelog
