# Firejail profile for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/torbrowser-launcher.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.tor-browser-en
noblacklist ${HOME}/.config/torbrowser
noblacklist ${HOME}/.local/share/torbrowser

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${HOME}/.tor-browser-en
whitelist ${HOME}/.config/torbrowser
whitelist ${HOME}/.local/share/torbrowser
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-bin bash,cp,dirname,env,expr,file,getconf,gpg,grep,id,ln,mkdir,python*,readlink,rm,sed,sh,tail,test,tor-browser-en,torbrowser-launcher
private-dev
private-etc fonts
private-tmp

noexec /tmp
