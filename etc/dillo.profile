# Firejail profile for Dillo web browser

noblacklist ~/.dillo
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6
seccomp
tracelog

whitelist ${DOWNLOADS}
mkdir ~/.dillo
whitelist ~/.dillo
mkdir ~/.fltk
whitelist ~/.fltk

include /etc/firejail/whitelist-common.inc
