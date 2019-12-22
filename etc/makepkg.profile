# Firejail profile for makepkg
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include makepkg.local
# Persistent global definitions
include globals.local

# Note: see this Arch forum discussion https://bbs.archlinux.org/viewtopic.php?pid=1743138
# for potential issues and their solutions when Firejailing makepkg

# This profile could be significantly strengthened by adding the following to makepkg.local
# whitelist ${HOME}/<Your Build Folder>
# whitelist ${HOME}/.gnupg

# Enable severely restricted access to ${HOME}/.gnupg
noblacklist ${HOME}/.gnupg
#private-etc alternatives,ca-certificates,crypto-policies,dbus-1,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
read-only ${HOME}/.gnupg/gpg.conf
read-only ${HOME}/.gnupg/trustdb.gpg
read-only ${HOME}/.gnupg/pubring.kbx
blacklist ${HOME}/.gnupg/random_seed
blacklist ${HOME}/.gnupg/pubring.kbx~
blacklist ${HOME}/.gnupg/private-keys-v1.d
blacklist ${HOME}/.gnupg/crls.d
blacklist ${HOME}/.gnupg/openpgp-revocs.d

# Arch Linux (based distributions) need access to /var/lib/pacman. As we drop all capabilities this is automatically read-only.
noblacklist /var/lib/pacman

include disable-common.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc

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
