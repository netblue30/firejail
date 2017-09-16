# Firejail profile for dooble-qt4
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/dooble-qt4.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.dooble

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.dooble
mkdir ~/usr/lib/dooble-qt4
whitelist ${DOWNLOADS}
whitelist ~/.config/keepassx
whitelist ~/.config/lastpass
whitelist ~/.dooble
whitelist ~/.keepassx
whitelist ~/.lastpass
whitelist ~/keepassx.kdbx
whitelist ~/usr/lib/dooble
whitelist ~/usr/lib/dooble-qt4
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp
tracelog
