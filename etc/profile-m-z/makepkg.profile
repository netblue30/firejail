# Firejail profile for makepkg
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include makepkg.local
# Persistent global definitions
include globals.local

deny  /tmp/.X11-unix
deny  ${RUNUSER}/wayland-*

# Note: see this Arch forum discussion https://bbs.archlinux.org/viewtopic.php?pid=1743138
# for potential issues and their solutions when Firejailing makepkg

# This profile could be significantly strengthened by adding the following to makepkg.local
# whitelist ${HOME}/<Your Build Folder>
# whitelist ${HOME}/.gnupg

# Enable severely restricted access to ${HOME}/.gnupg
nodeny  ${HOME}/.gnupg
read-only ${HOME}/.gnupg/gpg.conf
read-only ${HOME}/.gnupg/trustdb.gpg
read-only ${HOME}/.gnupg/pubring.kbx
deny  ${HOME}/.gnupg/random_seed
deny  ${HOME}/.gnupg/pubring.kbx~
deny  ${HOME}/.gnupg/private-keys-v1.d
deny  ${HOME}/.gnupg/crls.d
deny  ${HOME}/.gnupg/openpgp-revocs.d

# Arch Linux (based distributions) need access to /var/lib/pacman. As we drop all capabilities this is automatically read-only.
nodeny  /var/lib/pacman

include disable-common.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
machine-id
ipc-namespace
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
shell none
tracelog

disable-mnt
private-cache
private-tmp

memory-deny-write-execute
