# Firejail profile for wire-desktop
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/wire-desktop.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/Wire

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.config/Wire
whitelist ${HOME}/.config/Wire
whitelist ${DOWNLOADS}

include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp
shell none

# Note: The current version of Wire is located in /opt/wire-desktop/wire-desktop, and therefore
# it is not in PATH. To use Wire with firejail, run "firejail /opt/wire-desktop/wire-desktop"

disable-mnt
private-bin wire-desktop
private-dev
private-etc fonts,machine-id,resolv.conf,ca-certificates,ssl,pki,crypto-policies
private-tmp
