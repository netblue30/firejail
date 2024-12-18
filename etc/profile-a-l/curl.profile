# Firejail profile for curl
# Description: Command line tool for transferring data with URL syntax
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include curl.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.config/curlrc # since curl 7.73.0
# curl 7.74.0 introduces experimental support for HSTS cache
# https://daniel.haxx.se/blog/2020/11/03/hsts-your-curl/
# Technically this file can be anywhere but let's assume users have it in ${HOME}/.curl-hsts.
# If your setup diverts, add 'blacklist /path/to/curl/hsts/file' to your disable-programs.local
# and 'noblacklist /path/to/curl/hsts/file' to curl.local to keep the sandbox logic intact.
noblacklist ${HOME}/.curl-hsts
noblacklist ${HOME}/.curlrc

blacklist ${RUNUSER}

# If you use nvm, add the below lines to your curl.local
#ignore read-only ${HOME}/.nvm
#noblacklist ${HOME}/.nvm

include disable-common.inc
include disable-exec.inc
include disable-programs.inc
include disable-x11.inc
# Depending on workflow you can add 'include disable-xdg.inc' to your curl.local.
#include disable-xdg.inc

include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
no3d
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol inet,inet6
seccomp
tracelog

#private-bin curl
private-cache
private-dev
#private-etc alternatives,ca-certificates,crypto-policies,pki,resolv.conf,ssl
private-etc @tls-ca
private-tmp

dbus-user none
dbus-system none

restrict-namespaces
