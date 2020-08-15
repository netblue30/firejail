# Firejail profile for psi
# Description: Native XMPP client with GPG support
# This file is overwritten after every install/update
# Persistent local customizations
include psi.local
# Persistent global definitions
include globals.local

# Uncomment for GPG
# noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.cache/psi
noblacklist ${HOME}/.cache/Psi
noblacklist ${HOME}/.config/psi
noblacklist ${HOME}/.local/share/psi
noblacklist ${HOME}/.local/share/Psi

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

# Uncomment for GPG
# mkdir ${HOME}/.gnupg
mkdir ${HOME}/.cache/psi
mkdir ${HOME}/.cache/Psi
mkdir ${HOME}/.config/psi
mkdir ${HOME}/.local/share/psi
mkdir ${HOME}/.local/share/Psi
# Uncomment for GPG
# whitelist ${HOME}/.gnupg
whitelist ${HOME}/.cache/psi
whitelist ${HOME}/.cache/Psi
whitelist ${HOME}/.config/psi
whitelist ${HOME}/.local/share/psi
whitelist ${HOME}/.local/share/Psi
whitelist ${DOWNLOADS}
# Uncomment for GPG
# whitelist /usr/share/gnupg
# whitelist /usr/share/gnupg2
whitelist /usr/share/psi
# Uncomment for GPG
# whitelist ${RUNUSER}/gnupg
# whitelist ${RUNUSER}/keyring
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
nou2f
protocol unix,inet,inet6,netlink
seccomp !chroot
shell none
# breaks on Arch
# tracelog

disable-mnt
# Add "gpg,gpg2,gpg-agent,pinentry,pinentry-gtk-2" for GPG
private-bin getopt,psi
private-cache
private-dev
private-etc alsa,alternatives,asound.conf,ca-certificates,crypto-policies,drirc,fonts,gcrypt,group,hostname,hosts,ld.so.cache,ld.so.conf,machine-id,passwd,pki,pulse,resolv.conf,selinux,ssl,xdg
private-tmp

dbus-user none
dbus-system none
