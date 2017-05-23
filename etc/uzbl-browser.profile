# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/uzbl-browser.local

# Firejail profile for uzbl-browser

noblacklist ~/.config/uzbl
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
mkdir ~/.local/share/uzbl
whitelist ~/.local/share/uzbl

whitelist ${DOWNLOADS}

mkdir ~/.gnupg
whitelist ~/.gnupg
mkdir ~/.password-store
whitelist ~/.password-store

include /etc/firejail/whitelist-common.inc
