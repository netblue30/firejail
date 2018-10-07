# Firejail profile for dillo
# Description: Small and fast web browser
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/dillo.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.dillo

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

mkdir ${HOME}/.dillo
mkdir ${HOME}/.fltk
whitelist ${DOWNLOADS}
whitelist ${HOME}/.dillo
whitelist ${HOME}/.fltk
include /etc/firejail/whitelist-common.inc
include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nonewprivs
noroot
notv
protocol unix,inet,inet6
seccomp
tracelog

private-dev
private-tmp
