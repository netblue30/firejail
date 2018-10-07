# Firejail profile for calibre
# Description: Powerful and easy to use e-book manager
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/calibre.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/calibre
noblacklist ${HOME}/.config/calibre
noblacklist ${DOCUMENTS}

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-xdg.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none
tracelog

private-dev
private-tmp

noexec ${HOME}
noexec /tmp
