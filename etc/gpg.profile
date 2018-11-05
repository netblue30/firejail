# Firejail profile for gpg
# Description: GNU Privacy Guard -- minimalist public key operations
# This file is overwritten after every install/update
# Persistent local customizations
include gpg.local
# Persistent global definitions
include globals.local

blacklist /tmp/.X11-unix

noblacklist ${HOME}/.gnupg

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
# Causes gpg to hang
#shell none
tracelog

# private-bin gpg,gpg-agent
private-cache
private-dev

# On Arch 'archlinux-keyring' needs read-write access to /etc/pacman.d/gnupg
# and /usr/share/pacman/keyrings. Although this works, it makes
# installing/upgrading archlinux-keyring extremely slow.
read-write /etc/pacman.d/gnupg
read-write /usr/share/pacman/keyrings
