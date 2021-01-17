# Firejail profile for telegram
# This file is overwritten after every install/update
# Persistent local customizations
include telegram.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.TelegramDesktop
noblacklist ${HOME}/.local/share/TelegramDesktop

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.TelegramDesktop
mkdir ${HOME}/.local/share/TelegramDesktop
whitelist ${DOWNLOADS}
whitelist ${HOME}/.TelegramDesktop
whitelist ${HOME}/.local/share/TelegramDesktop
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6,netlink
seccomp

disable-mnt
private-cache
private-etc alsa,alternatives,ca-certificates,crypto-policies,fonts,group,ld.so.cache,localtime,machine-id,os-release,pki,pulse,resolv.conf,ssl,xdg
private-tmp
