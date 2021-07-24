# Firejail profile for git
# Description: Fast, scalable, distributed revision control system
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include git.local
# Persistent global definitions
include globals.local

nodeny  ${HOME}/.config/git
nodeny  ${HOME}/.config/nano
nodeny  ${HOME}/.emacs
nodeny  ${HOME}/.emacs.d
nodeny  ${HOME}/.gitconfig
nodeny  ${HOME}/.git-credentials
nodeny  ${HOME}/.gnupg
nodeny  ${HOME}/.nanorc
nodeny  ${HOME}/.vim
nodeny  ${HOME}/.viminfo

# Allow ssh (blacklisted by disable-common.inc)
include allow-ssh.inc

deny  /tmp/.X11-unix
deny  ${RUNUSER}/wayland-*

include disable-common.inc
include disable-exec.inc
include disable-passwdmgr.inc
include disable-programs.inc

allow  /usr/share/git
allow  /usr/share/git-core
allow  /usr/share/gitgui
allow  /usr/share/gitweb
allow  /usr/share/nano
include whitelist-usr-share-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
ipc-namespace
machine-id
netfilter
no3d
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

private-cache
private-dev

memory-deny-write-execute
