# Firejail profile for makepkg
# Description: A utility to automate the building of Arch Linux packages
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include makepkg.local
# Persistent global definitions
include globals.local

blacklist ${RUNUSER}/wayland-*

# Note: see this Arch forum discussion https://bbs.archlinux.org/viewtopic.php?pid=1743138
# for potential issues and their solutions when Firejailing makepkg

# This profile could be significantly strengthened by adding the following to makepkg.local
#whitelist ${HOME}/<Your Build Folder>
#whitelist ${HOME}/.gnupg

# Enable severely restricted access to ${HOME}/.gnupg
noblacklist ${HOME}/.gnupg
read-only ${HOME}/.gnupg/trustdb.gpg
read-only ${HOME}/.gnupg/pubring.kbx
blacklist ${HOME}/.gnupg/crls.d
blacklist ${HOME}/.gnupg/openpgp-revocs.d
blacklist ${HOME}/.gnupg/private-keys-v1.d
blacklist ${HOME}/.gnupg/pubring.kbx~
blacklist ${HOME}/.gnupg/random_seed

# Arch Linux (based distributions) need access to /var/lib/pacman. As we drop all capabilities this is automatically read-only.
noblacklist /var/lib/pacman

include disable-common.inc
include disable-exec.inc
include disable-programs.inc
include disable-x11.inc

caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
nonewprivs
# noroot is only disabled to allow the creation of kernel headers from an official PKGBUILD.
#noroot
nosound
nou2f
notv
novideo
protocol unix,inet,inet6
seccomp
tracelog

disable-mnt
private-cache
private-tmp

memory-deny-write-execute
restrict-namespaces
