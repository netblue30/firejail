# Firejail profile for git-cola
# Description: Linux native frontend for Git
# This file is overwritten after every install/update
# Persistent local customizations
include git-cola.local
# Persistent global definitions
include globals.local

ignore noexec ${HOME}

noblacklist ${HOME}/.config/git
noblacklist ${HOME}/.config/git-cola
noblacklist ${HOME}/.gitconfig
noblacklist ${HOME}/.git-credentials
noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.ssh
noblacklist ${HOME}/.subversion
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

# Uncomment to allow ssh,gpg
# whitelist ${RUNUSER}/gnupg
# whitelist ${RUNUSER}/keyring
# Put your editor,diff viewer,gnupg path below
whitelist /usr/share/git
whitelist /usr/share/git-cola
whitelist /usr/share/git-core
whitelist /usr/share/git-gui
whitelist /usr/share/gitk
whitelist /usr/share/gitweb
whitelist /usr/share/gnupg
include whitelist-runuser-common.inc
include whitelist-usr-share-common.inc
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

private-bin atom,basename,bash,colordiff,diff,emacs,envsubst,fldiff,geany,gedit,gettext,git,git gui,git-cola,git-dag,gitk,gpg,gpg-agent,gvim,leafpad,meld,mousepad,nano,notepadqq,nvim,pinentry,pinentry-gtk-2,ps,python*,sh,ssh,ssh-agent,tclsh,tr,vim,vimdiff,wc,which,xed
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,dconf,fonts,gcrypt,gitconfig,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,localtime,login.defs,machine-id,mime.types,nsswitch.conf,passwd,pki,resolv.conf,selinux,ssh,ssl,X11,xdg
private-tmp

# Breaks meld as diff viewer
# dbus-user filter
# Uncomment if you need keyring access
# dbus-user.talk org.freedesktop.secrets
dbus-system none

read-only ${HOME}/.git-credentials
# Comment if you sign commits with GPG
# read-only ${HOME}/.gnupg
# Comment if you need to allow hosts
read-only ${HOME}/.ssh
