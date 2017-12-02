# Firejail profile for brave
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/brave.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/brave
# brave uses gpg for built-in password manager
noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.pki

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.config/brave
mkdir ${HOME}/.pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.config/KeePass
whitelist ${HOME}/.config/brave
whitelist ${HOME}/.config/keepass
whitelist ${HOME}/.config/lastpass
whitelist ${HOME}/.keepass
whitelist ${HOME}/.lastpass
whitelist ${HOME}/.pki
include /etc/firejail/whitelist-common.inc

# caps.drop all
netfilter
# nonewprivs
# noroot
nodvd
notv
# protocol unix,inet,inet6,netlink
# seccomp

disable-mnt
