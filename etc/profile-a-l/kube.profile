# Firejail profile for kube
# Description: Qt mail client
# This file is overwritten after every install/update
# Persistent local customizations
include kube.local
# Persistent global definitions
include globals.local

# Comment to use GPG
noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.cache/kube
noblacklist ${HOME}/.config/kube
noblacklist ${HOME}/.config/sink
noblacklist ${HOME}/.local/share/kube
noblacklist ${HOME}/.local/share/sink

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

# Uncomment to allow gpg
# whitelist ${RUNUSER}/gnupg
whitelist /usr/share/kube
# Uncomment to allow gpg
# whitelist /usr/share/gnupg
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
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
shell none
tracelog

disable-mnt
# Add gpg,gpg2,pinentry,qgpgme to allow gpg
private-bin kube,sink_synchronizer
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,gcrypt,gtk-2.0,gtk-3.0,hostname,hosts,pki,resolv.conf,selinux,ssl,xdg
private-tmp

dbus-user none
dbus-system none

# Comment to use GPG
read-only ${HOME}/.gnupg
