# Firejail profile for git-cola
# Description: Linux native frontend for Git
# This file is overwritten after every install/update
# Persistent local customizations
include git-cola.local
# Persistent global definitions
include globals.local

ignore noexec ${HOME}

nodeny  ${HOME}/.gitconfig
nodeny  ${HOME}/.git-credentials
nodeny  ${HOME}/.gnupg
nodeny  ${HOME}/.subversion
nodeny  ${HOME}/.config/git
nodeny  ${HOME}/.config/git-cola
# Add your editor/diff viewer config paths and the next line to your git-cola.local to load settings.
#noblacklist ${HOME}/

# Allow python (blacklisted by disable-interpreters.inc)
include allow-python2.inc
include allow-python3.inc

# Allow ssh (blacklisted by disable-common.inc)
include allow-ssh.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

allow  ${RUNUSER}/gnupg
allow  ${RUNUSER}/keyring
# Add additional whitelist paths below /usr/share to your git-cola.local to support your editor/diff viewer.
allow  /usr/share/git
allow  /usr/share/git-cola
allow  /usr/share/git-core
allow  /usr/share/git-gui
allow  /usr/share/gitk
allow  /usr/share/gitweb
allow  /usr/share/gnupg
allow  /usr/share/gnupg2
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
noinput
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

# Add your own diff viewer,editor,pinentry program to private-bin in your git-cola.local.
#private-bin pinentry-curses,pinentry-emacs,pinentry-fltk,pinentry-gnome3,pinentry-gtk,pinentry-gtk2,pinentry-gtk-2,pinentry-qt,pinentry-qt4,pinentry-tty,pinentry-x2go,pinentry-kwallet" for gpg
private-bin basename,bash,cola,envsubst,gettext,git,git-cola,git-dag,git-gui,gitk,gpg,gpg-agent,nano,ps,python*,sh,ssh,ssh-agent,tclsh,tr,wc,which,xed
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,dconf,fonts,gcrypt,gitconfig,gtk-2.0,gtk-3.0,host.conf,hostname,hosts,localtime,login.defs,machine-id,mime.types,nsswitch.conf,passwd,pki,resolv.conf,selinux,ssh,ssl,X11,xdg
private-tmp
writable-run-user

# dbus-user filtering breaks meld as diff viewer
# Add the next line to your git-cola.local if you don't use meld.
#dbus-user filter
# Add the next line to your git-cola.local if you need keyring access
#dbus-user.talk org.freedesktop.secrets
dbus-system none

read-only ${HOME}/.git-credentials

# Add 'ignore read-only ${HOME}/.ssh' to your git-cola.local if you need to allow hosts.
read-only ${HOME}/.ssh
