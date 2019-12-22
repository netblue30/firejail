# Firejail profile for gcloud
# This file is overwritten after every install/update
# Persistent local customizations
include gcloud.local
# Persistent global definitions
include globals.local

private-etc Trolltech.conf,X11,alsa,alternatives,asound.conf,bumblebee,ca-certificates,crypto-policies,dconf,drirc,fonts,gconf,glvnd,group,gtk-2.0,gtk-3.0,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,pango,passwd,pki,protocols,pulse,resolv.conf,rpc,services,ssl,xdg
# noexec ${HOME} will break user-local installs of gcloud tooling
ignore noexec ${HOME}

noblacklist ${HOME}/.boto
noblacklist ${HOME}/.config/gcloud
noblacklist /var/run/docker.sock

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-programs.inc

apparmor
caps.drop all
machine-id
netfilter
nodbus
nodvd
# required for sudo-free docker
#nogroups
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-dev
private-tmp
