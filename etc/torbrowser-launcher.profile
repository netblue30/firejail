# Firejail profile for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/torbrowser-launcher.local
# Persistent global definitions
include /etc/firejail/globals.local


noblacklist ~/.config/torbrowser
whitelist ~/.config/torbrowser
noblacklist ~/.local/share/torbrowser
whitelist ~/.local/share/torbrowser

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

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

private-bin torbrowser-launcher,python2.7,python,bash,dash,sh,grep,tail,env,gpg,id,readlink,dirname,test,mkdir,ln,sed,cp,rm,getconf
private-dev
private-etc fonts
private-tmp

noexec /tmp
