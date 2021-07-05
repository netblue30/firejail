# Firejail profile for kwin_x11
# This file is overwritten after every install/update
# Persistent local customizations
include kwin_x11.local
# Persistent global definitions
include globals.local

# fix automatical kwin_x11 sandboxing:
# echo KDEWM=kwin_x11 >> ~/.pam_environment

nodeny  ${HOME}/.cache/kwin
nodeny  ${HOME}/.config/kwinrc
nodeny  ${HOME}/.config/kwinrulesrc
nodeny  ${HOME}/.local/share/kwin

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-shell.inc
include disable-xdg.inc

include whitelist-var-common.inc

caps.drop all
netfilter
nodvd
nogroups
noinput
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix
seccomp
shell none
tracelog

disable-mnt
private-bin kwin_x11
private-dev
private-etc alternatives,drirc,fonts,kde5rc,ld.so.cache,machine-id,xdg
private-tmp
