# Firejail profile for tor-browser-en
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/tor-browser-en.local
# Persistent global definitions
include /etc/firejail/globals.local


noblacklist ${HOME}/.tor-browser-en

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

whitelist ${HOME}/.tor-browser-en
include /etc/firejail/whitelist-common.inc

caps.drop all
noroot
seccomp
shell none

private-bin bash,grep,sed,tail,tor-browser-en,env,id,readlink,dirname,test,mkdir,ln,sed,cp,rm,getconf,file,expr
private-tmp

noexec /tmp
