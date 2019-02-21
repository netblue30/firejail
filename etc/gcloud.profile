# Firejail profile for gcloud
# This file is overwritten after every install/update
# Persistent local customizations
include gcloud.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.boto
noblacklist ${HOME}/.config/gcloud
noblacklist /var/run/docker.sock

include disable-common.inc
include disable-devel.inc
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
private-etc alternatives,ca-certificates,ssl,hosts,localtime,nsswitch.conf,resolv.conf,pki,crypto-policies,ld.so.cache
private-tmp

noexec /tmp

# will break user-local installs of gcloud tooling
# noexec ${HOME}
