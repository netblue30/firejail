# Firejail profile for spotify
# This file is overwritten after every install/update
# Persistent local customizations
include spotify.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/spotify
noblacklist ${HOME}/.config/spotify
noblacklist ${HOME}/.local/share/spotify

blacklist ${HOME}/.bashrc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/spotify
mkdir ${HOME}/.config/spotify
mkdir ${HOME}/.local/share/spotify
whitelist ${HOME}/.cache/spotify
whitelist ${HOME}/.config/spotify
whitelist ${HOME}/.local/share/spotify
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
#nodbus - dbus needed for MPRIS
nodvd
nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

disable-mnt
private-bin bash,cat,dirname,find,grep,head,rm,sh,spotify,tclsh,touch,zenity
private-dev
# Comment the next line or put 'ignore private-etc' in your spotify.local if want to see the albums covers or if you want to use the radio
private-etc alternatives,ca-certificates,crypto-policies,fonts,group,host.conf,hosts,ld.so.cache,machine-id,nsswitch.conf,pki,pulse,resolv.conf,ssl
private-opt spotify
private-srv none
private-tmp

