# Firejail profile for joplin
# Description: A note taking and to-do application
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include joplin.local
# Persistent global definitions
include globals.local

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}

noblacklist ${HOME}/.config/joplin
noblacklist ${HOME}/.config/nano
noblacklist ${HOME}/.emacs
noblacklist ${HOME}/.emacs.d
noblacklist ${HOME}/.nanorc
noblacklist ${HOME}/.vim
noblacklist ${HOME}/.vimrc

include allow-bin-sh.inc
include allow-nodejs.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

mkdir ${HOME}/.config/joplin
whitelist ${HOME}/.config/joplin
whitelist ${HOME}/.config/nano
whitelist ${HOME}/.emacs
whitelist ${HOME}/.emacs.d
whitelist ${HOME}/.nanorc
whitelist ${HOME}/.vim
whitelist ${HOME}/.vimrc
include whitelist-common.inc
include whitelist-runuser-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
seccomp.block-secondary
shell none
tracelog

disable-mnt
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,host.conf,hostname,hosts,ld.so.cache,ld.so.conf,ld.so.conf.d,ld.so.preload,locale,locale.alias,locale.conf,localtime,mime.types,nsswitch.conf,pki,protocols,resolv.conf,rpc,services,ssl,xdg
private-tmp

read-only ${HOME}/.config/nano
read-only ${HOME}/.emacs
read-only ${HOME}/.emacs.d
read-only ${HOME}/.nanorc
read-only ${HOME}/.vim
read-only ${HOME}/.viminfo
read-only ${HOME}/.vimrc

dbus-user none
dbus-system none
