# Firejail profile for git-cola
# Description: Linux native frontend for Git
# This file is overwritten after every install/update
# Persistent local customizations
include git-cola.local
# Persistent global definitions
include globals.local

ignore noexec ${HOME}

noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.git-credentials
noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.ssh
noblacklist ${HOME}/.config/git
noblacklist ${HOME}/.config/git-cola
# Put your editor,diff viewer config path below and uncomment to load settings
# noblacklist ${HOME}/

include allow-python2.inc
include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

include whitelist-runuser-common.inc
include whitelist-var-common.inc

apparmor
caps.drop all
machine-id
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
nou2f
novideo
protocol unix,inet,inet6,netlink
seccomp
shell none
tracelog

# private-bin atom,bash,colordiff,emacs,fldiff,geany,gedit,git,git gui,git-cola,git-dag,gitk,gpg,gvim,leafpad,meld,mousepad,nano,notepadqq,python*,sh,ssh,vim,vimdiff,which,xed
private-cache
private-dev
# Comment if you sign commits with GPG
private-etc alternatives,ca-certificates,crypto-policies,fonts,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,localtime,login.defs,machine-id,mime.types,nsswitch.conf,passwd,pki,resolv.conf,selinux,ssl,X11,xdg
private-tmp

dbus-user filter
# Uncomment if you need keyring access
# dbus-user.talk org.freedesktop.secrets
dbus-system none

read-only ${HOME}/.ssh
read-only ${HOME}/.gnupg
read-only ${HOME}/.git-credentials
