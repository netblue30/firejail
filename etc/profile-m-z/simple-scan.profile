# Firejail profile for simple-scan
# Description: Simple Scanning Utility
# This file is overwritten after every install/update
# Persistent local customizations
include simple-scan.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.cache/simple-scan
noblacklist ${DOCUMENTS}

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

whitelist /usr/share/hplip
whitelist /usr/share/simple-scan
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
#novideo
protocol unix,inet,inet6,netlink
# blacklisting of ioperm system calls breaks simple-scan
seccomp !ioperm
tracelog

#private-bin simple-scan
#private-dev
#private-etc alternatives,ca-certificates,crypto-policies,fonts,pki,ssl
#private-tmp

restrict-namespaces
