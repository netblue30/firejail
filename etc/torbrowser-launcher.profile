# Firejail profile for torbrowser-launcher
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/torbrowser-launcher.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.config/torbrowser
noblacklist ${HOME}/.local/share/torbrowser

# Allow python (blacklisted by disable-interpreters.inc)
noblacklist ${PATH}/python2*
noblacklist ${PATH}/python3*
noblacklist /usr/lib/python2*
noblacklist /usr/lib/python3*

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.config/torbrowser
mkdir ${HOME}/.local/share/torbrowser
whitelist ${HOME}/.config/torbrowser
whitelist ${HOME}/.local/share/torbrowser
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

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
private-bin bash,cp,dirname,env,expr,file,getconf,gpg,grep,id,ln,mkdir,python*,readlink,rm,sed,sh,tail,tclsh,test,tor-browser-en,torbrowser-launcher
private-dev
private-etc fonts,hostname,hosts,resolv.conf,pki,ssl,ca-certificates,crypto-policies,alsa,asound.conf,pulse,machine-id,ld.so.cache
private-tmp

noexec /tmp
