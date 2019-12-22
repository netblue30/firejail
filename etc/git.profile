# Firejail profile for git
# Description: Fast, scalable, distributed revision control system
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include git.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/git
noblacklist ${HOME}/.config/nano
noblacklist ${HOME}/.emacs
noblacklist ${HOME}/.emacs.d
noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.git-credentials
noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.nanorc
noblacklist ${HOME}/.ssh
noblacklist ${HOME}/.vim
noblacklist ${HOME}/.viminfo

blacklist /tmp/.X11-unix

include disable-common.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc

whitelist /usr/share/git
whitelist /usr/share/git-core
whitelist /usr/share/gitgui
whitelist /usr/share/gitweb
whitelist /usr/share/nano
include whitelist-usr-share-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
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

private-cache
private-dev
#private-etc alternatives,ca-certificates,crypto-policies,dbus-1,gitattributes,gitconfig,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg

memory-deny-write-execute
