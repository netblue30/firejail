# Firejail profile for dillo
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/dillo.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.dillo

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.dillo
mkdir ~/.fltk
whitelist ${DOWNLOADS}
whitelist ~/.dillo
whitelist ~/.fltk
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp
tracelog
