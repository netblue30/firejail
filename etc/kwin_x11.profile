# Firejail profile for kwin_x11
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/kwin_x11.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ${HOME}/.cache/kwin
noblacklist ${HOME}/.config/kwinrc
noblacklist ${HOME}/.config/kwinrulesrc
noblacklist ${HOME}/.local/share/kwin

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-interpreters.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

include /etc/firejail/whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix
seccomp
shell none
tracelog

disable-mnt
private-bin kwin_x11
private-dev
private-etc drirc,fonts,kde5rc,ld.so.cache,machine-id,xdg
private-tmp

noexec ${HOME}
noexec /tmp
