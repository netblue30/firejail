# Firejail profile for makepkg
# This file is overwritten after every install/update

# Note: see this Arch forum discussion https://bbs.archlinux.org/viewtopic.php?pid=1743138
# for potential issues and their solutions when Firejailing makepkg

# This profile could be significantly strengthened by adding the following to makepkg.local
# whitelist ${HOME}/<Your Build Folder>
# whitelist ${HOME}/.gnupg

quiet
# Persistent local customizations
include /etc/firejail/makepkg.local
# Persistent global definitions
include /etc/firejail/globals.local


# Enable severely restricted access to ${HOME}/.gnupg
noblacklist ${HOME}/.gnupg
read-only ${HOME}/.gnupg/gpg.conf
read-only ${HOME}/.gnupg/trustdb.gpg
read-only ${HOME}/.gnupg/pubring.kbx
blacklist ${HOME}/.gnupg/random_seed
blacklist ${HOME}/.gnupg/pubring.kbx~
blacklist ${HOME}/.gnupg/private-keys-v1.d
blacklist ${HOME}/.gnupg/crls.d
blacklist ${HOME}/.gnupg/openpgp-revocs.d


# Need to be able to read /var/lib/pacman, {Note no capabilities so automatically read-only}
noblacklist /var/lib/pacman

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
ipc-namespace
netfilter
no3d
nodvd
nogroups
nonewprivs
# noroot is only disabled to allow the creation of kernel headers from an official PKGBUILD.
#noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
private-tmp

memory-deny-write-execute
noexec ${HOME}
noexec /tmp
