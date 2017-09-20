# Firejail profile for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/torbrowser-launcher.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.tor-browser-en
noblacklist ~/.config/torbrowser
noblacklist ~/.local/share/torbrowser

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ~/.tor-browser-en
whitelist ~/.config/torbrowser
whitelist ~/.local/share/torbrowser
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

private-bin bash,cp,dash,dirname,env,expr,file,getconf,gpg,grep,id,ln,mkdir,python,python2.7,readlink,rm,sed,sh,tail,test,tor-browser-en,torbrowser-launcher
private-dev
private-etc fonts
private-tmp

noexec /tmp
