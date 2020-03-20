# Firejail profile for falkon
# Description: Lightweight web browser based on Qt WebEngine
# This file is overwritten after every install/update
# Persistent local customizations
include falkon.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/falkon
noblacklist ${HOME}/.config/falkon

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/falkon
mkdir ${HOME}/.config/falkon
whitelist ${DOWNLOADS}
whitelist ${HOME}/.cache/falkon
whitelist ${HOME}/.config/falkon
include whitelist-common.inc
#X11: include whitelist-runuser-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
# blacklisting of chroot system calls breaks falkon
seccomp !chroot
# tracelog

private-dev
# private-etc alternatives,passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,gtk-2.0,pango,fonts,adobe,mime.types,mailcap,asound.conf,pulse,machine-id,ca-certificates,ssl,pki,crypto-policies
# private-tmp - interferes with the opening of downloaded files

