# Firejail profile for zaproxy
# Description: Integrated penetration testing tool for finding vulnerabilities in web applications
# This file is overwritten after every install/update
# Persistent local customizations
include zaproxy.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.ZAP

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc

mkdir ${HOME}/.java
mkdir ${HOME}/.ZAP
whitelist ${HOME}/.java
whitelist ${HOME}/.ZAP
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
ipc-namespace
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
protocol unix,inet,inet6
seccomp

disable-mnt
private-dev
private-tmp

restrict-namespaces
