# Firejail profile for gcloud
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/gcloud.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.boto
noblacklist ${HOME}/.config/gcloud
noblacklist /var/run/docker.sock

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

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
protocol unix,inet,inet6
seccomp
shell none
tracelog

disable-mnt
private-dev
private-etc ca-certificates,ssl,hosts,localtime,nsswitch.conf,resolv.conf,pki,crypto-policies,ld.so.cache
private-tmp

noexec /tmp

# will break user-local installs of gcloud tooling
# noexec ${HOME}
