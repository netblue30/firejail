# Firejail profile for mcabber
# Description: Small Jabber (XMPP) console client
# This file is overwritten after every install/update
# Persistent local customizations
include mcabber.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.mcabber
noblacklist ${HOME}/.mcabberrc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-shell.inc

caps.drop all
netfilter
nodvd
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol inet,inet6
seccomp
shell none

private-bin mcabber
private-dev
private-etc alternatives,ca-certificates,crypto-policies,pki,ssl
