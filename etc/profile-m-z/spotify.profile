# Firejail profile for spotify
# This file is overwritten after every install/update
# Persistent local customizations
include spotify.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.cache/spotify
nodeny  ${HOME}/.config/spotify
nodeny  ${HOME}/.local/share/spotify

deny  ${HOME}/.bashrc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.cache/spotify
mkdir ${HOME}/.config/spotify
mkdir ${HOME}/.local/share/spotify
allow  ${HOME}/.cache/spotify
allow  ${HOME}/.config/spotify
allow  ${HOME}/.local/share/spotify
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
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
# If you want to see album covers or want to use the radio, add 'ignore private-etc' to your spotify.local.
private-etc alternatives,ca-certificates,crypto-policies,fonts,group,host.conf,hosts,ld.so.cache,machine-id,nsswitch.conf,pki,pulse,resolv.conf,ssl
private-opt spotify
private-srv none
private-tmp

# dbus needed for MPRIS
# dbus-user none
# dbus-system none
