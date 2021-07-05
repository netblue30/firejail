# Firejail profile for dillo
# Description: Small and fast web browser
# This file is overwritten after every install/update
# Persistent local customizations
include dillo.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.dillo

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

mkdir ${HOME}/.dillo
mkdir ${HOME}/.fltk
allow  ${DOWNLOADS}
allow  ${HOME}/.dillo
allow  ${HOME}/.fltk
include whitelist-common.inc
include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
noinput
nonewprivs
noroot
notv
nou2f
protocol unix,inet,inet6
seccomp
tracelog

private-dev
private-tmp
