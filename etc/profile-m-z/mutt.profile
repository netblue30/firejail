# Firejail profile for mutt
# Description: Text-based mailreader supporting MIME, GPG, PGP and threading
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include mutt.local
# Persistent global definitions
include globals.local

nodeny  /var/mail
nodeny  /var/spool/mail
nodeny  ${DOCUMENTS}
nodeny  ${HOME}/.Mail
nodeny  ${HOME}/.bogofilter
nodeny  ${HOME}/.cache/mutt
nodeny  ${HOME}/.config/mutt
nodeny  ${HOME}/.config/nano
nodeny  ${HOME}/.elinks
nodeny  ${HOME}/.emacs
nodeny  ${HOME}/.emacs.d
nodeny  ${HOME}/.gnupg
nodeny  ${HOME}/.mail
nodeny  ${HOME}/.mailcap
nodeny  ${HOME}/.msmtprc
nodeny  ${HOME}/.mutt
nodeny  ${HOME}/.muttrc
nodeny  ${HOME}/.nanorc
nodeny  ${HOME}/.signature
nodeny  ${HOME}/.vim
nodeny  ${HOME}/.viminfo
nodeny  ${HOME}/.vimrc
nodeny  ${HOME}/.w3m
nodeny  ${HOME}/Mail
nodeny  ${HOME}/mail
nodeny  ${HOME}/postponed
nodeny  ${HOME}/sent

deny  /tmp/.X11-unix
deny  ${RUNUSER}/wayland-*

# Add the next lines to your mutt.local for oauth.py,S/MIME support.
#include allow-perl.inc
#include allow-python2.inc
#include allow-python3.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.Mail
mkdir ${HOME}/.bogofilter
mkdir ${HOME}/.cache/mutt
mkdir ${HOME}/.config/mutt
mkdir ${HOME}/.config/nano
mkdir ${HOME}/.elinks
mkdir ${HOME}/.emacs.d
mkdir ${HOME}/.gnupg
mkdir ${HOME}/.mail
mkdir ${HOME}/.mutt
mkdir ${HOME}/.vim
mkdir ${HOME}/.w3m
mkdir ${HOME}/Mail
mkdir ${HOME}/mail
mkdir ${HOME}/postponed
mkdir ${HOME}/sent
mkfile ${HOME}/.emacs
mkfile ${HOME}/.mailcap
mkfile ${HOME}/.msmtprc
mkfile ${HOME}/.muttrc
mkfile ${HOME}/.nanorc
mkfile ${HOME}/.signature
mkfile ${HOME}/.viminfo
mkfile ${HOME}/.vimrc
allow  ${DOCUMENTS}
allow  ${DOWNLOADS}
allow  ${HOME}/.Mail
allow  ${HOME}/.bogofilter
allow  ${HOME}/.cache/mutt
allow  ${HOME}/.config/mutt
allow  ${HOME}/.config/nano
allow  ${HOME}/.elinks
allow  ${HOME}/.emacs
allow  ${HOME}/.emacs.d
allow  ${HOME}/.gnupg
allow  ${HOME}/.mail
allow  ${HOME}/.mailcap
allow  ${HOME}/.msmtprc
allow  ${HOME}/.mutt
allow  ${HOME}/.muttrc
allow  ${HOME}/.nanorc
allow  ${HOME}/.signature
allow  ${HOME}/.vim
allow  ${HOME}/.viminfo
allow  ${HOME}/.vimrc
allow  ${HOME}/.w3m
allow  ${HOME}/Mail
allow  ${HOME}/mail
allow  ${HOME}/postponed
allow  ${HOME}/sent
allow  /usr/share/gnupg
allow  /usr/share/gnupg2
allow  /usr/share/mutt
allow  /var/mail
allow  /var/spool/mail
include whitelist-common.inc
include whitelist-runuser-common.inc
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
seccomp.block-secondary
shell none
tracelog

# disable-mnt
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,fonts,gai.conf,gcrypt,gnupg,gnutls,hostname,hosts,hosts.conf,mail,mailname,Mutt,Muttrc,Muttrc.d,nntpserver,nsswitch.conf,passwd,pki,resolv.conf,ssl,terminfo,xdg
private-tmp
writable-run-user
writable-var

dbus-user none
dbus-system none

memory-deny-write-execute
read-only ${HOME}/.elinks
read-only ${HOME}/.nanorc
read-only ${HOME}/.signature
read-only ${HOME}/.w3m
