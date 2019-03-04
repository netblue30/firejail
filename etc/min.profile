# Firejail profile for min
# Description: A faster, smarter web browser.
# This file is overwritten after every install/update
# Persistent local customizations
include min.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/Min

noblacklist ${HOME}/.pki
noblacklist ${HOME}/.local/share/pki

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.pki
mkdir ${HOME}/.config/Min
mkdir ${HOME}/.local/share/pki
whitelist ${DOWNLOADS}
whitelist ${HOME}/.pki
whitelist ${HOME}/.config/Min
whitelist ${HOME}/.local/share/pki
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodbus
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
shell none

disable-mnt
# private-bin min
private-cache
private-dev
# private-etc below works fine on most distributions. There are some problems on CentOS.
private-etc alternatives,ca-certificates,ssl,machine-id,dconf,selinux,passwd,group,hostname,hosts,localtime,nsswitch.conf,resolv.conf,xdg,gtk-2.0,gtk-3.0,X11,pango,fonts,mime.types,mailcap,asound.conf,pulse,pki,crypto-policies,ld.so.cache
private-tmp

# memory-deny-write-execute
noexec ${HOME}
noexec /tmp
