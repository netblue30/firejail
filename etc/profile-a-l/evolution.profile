# Firejail profile for evolution
# Description: Groupware suite with mail client and organizer
# This file is overwritten after every install/update
# Persistent local customizations
include evolution.local
# Persistent global definitions
include globals.local

nodeny  /var/mail
nodeny  /var/spool/mail
nodeny  ${HOME}/.bogofilter
nodeny  ${HOME}/.cache/evolution
nodeny  ${HOME}/.config/evolution
nodeny  ${HOME}/.gnupg
nodeny  ${HOME}/.local/share/evolution
nodeny  ${HOME}/.pki
nodeny  ${HOME}/.local/share/pki

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

include whitelist-runuser-common.inc

caps.drop all
netfilter
# no3d breaks under wayland
#no3d
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
shell none

private-dev
private-tmp
writable-var
