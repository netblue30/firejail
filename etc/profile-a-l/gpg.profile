# Firejail profile for gpg
# Description: GNU Privacy Guard -- minimalist public key operations
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include gpg.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.gnupg

blacklist ${RUNUSER}/wayland-*

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-x11.inc

whitelist ${RUNUSER}/gnupg
whitelist ${RUNUSER}/keyring
whitelist /usr/share/gnupg
whitelist /usr/share/gnupg2
whitelist /usr/share/pacman/keyrings
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog

#private-bin gpg
private-cache
private-dev

# On Arch 'archlinux-keyring' needs read-write access to /etc/pacman.d/gnupg
# and /usr/share/pacman/keyrings. Although this works, it makes
# installing/upgrading archlinux-keyring extremely slow.
read-write /etc/pacman.d/gnupg
read-write /usr/share/pacman/keyrings
restrict-namespaces
