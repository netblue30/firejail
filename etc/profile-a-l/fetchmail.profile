# Firejail profile for fetchmail
# Description: SSL enabled POP3, APOP, IMAP mail gatherer/forwarder
# This file is overwritten after every install/update
# Persistent local customizations
include fetchmail.local
# Persistent global definitions
include globals.local

noblacklist ${HOME}/.fetchmailrc
noblacklist ${HOME}/.netrc

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-programs.inc

caps.drop all
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

#private-bin bash,chmod,fetchmail,procmail
private-dev
