# Firejail profile for libreoffice
# Description: Office productivity suite
# This file is overwritten after every install/update
# Persistent local customizations
include libreoffice.local
# Persistent global definitions
include globals.local

noblacklist /usr/local/sbin
noblacklist ${HOME}/.config/libreoffice

# libreoffice uses java for some functionality.
# Add 'ignore include allow-java.inc' to your libreoffice.local if you don't need that functionality.
# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

blacklist /usr/libexec

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-programs.inc

include whitelist-run-common.inc
include whitelist-var-common.inc

# Debian 10/Ubuntu 18.04 come with their own apparmor profile, but it is not in enforce mode.
# Add the next lines to your libreoffice.local to use the Ubuntu profile instead of firejail's apparmor profile.
#ignore apparmor
#ignore nonewprivs
#ignore protocol
#ignore seccomp
#ignore tracelog

apparmor
caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
notv
nou2f
novideo
protocol unix,inet,inet6
seccomp
tracelog

#private-bin libreoffice,sh,uname,dirname,grep,sed,basename,ls
private-cache
private-dev
private-etc @tls-ca,@x11,cups,gnupg,libreoffice,papersize,ssh
private-tmp

dbus-system none

restrict-namespaces
join-or-start libreoffice
