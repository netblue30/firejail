# Firejail profile for mutt
# Description: Text-based mailreader supporting MIME, GPG, PGP and threading
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include mutt.local
# Persistent global definitions
include globals.local

noblacklist /var/mail
noblacklist /var/spool/mail
noblacklist ${DOCUMENTS}
noblacklist ${HOME}/.Mail
noblacklist ${HOME}/.bogofilter
noblacklist ${HOME}/.cache/mutt
noblacklist ${HOME}/.config/mutt
noblacklist ${HOME}/.config/nano
noblacklist ${HOME}/.elinks
noblacklist ${HOME}/.emacs
noblacklist ${HOME}/.emacs.d
noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.mail
noblacklist ${HOME}/.mailcap
noblacklist ${HOME}/.msmtprc
noblacklist ${HOME}/.mutt
noblacklist ${HOME}/.muttrc
noblacklist ${HOME}/.nanorc
noblacklist ${HOME}/.signature
noblacklist ${HOME}/.vim
noblacklist ${HOME}/.viminfo
noblacklist ${HOME}/.vimrc
noblacklist ${HOME}/.w3m
noblacklist ${HOME}/Mail
noblacklist ${HOME}/mail
noblacklist ${HOME}/postponed
noblacklist ${HOME}/sent

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}/wayland-*

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
whitelist ${DOCUMENTS}
whitelist ${DOWNLOADS}
whitelist ${HOME}/.Mail
whitelist ${HOME}/.bogofilter
whitelist ${HOME}/.cache/mutt
whitelist ${HOME}/.config/mutt
whitelist ${HOME}/.config/nano
whitelist ${HOME}/.elinks
whitelist ${HOME}/.emacs
whitelist ${HOME}/.emacs.d
whitelist ${HOME}/.gnupg
whitelist ${HOME}/.mail
whitelist ${HOME}/.mailcap
whitelist ${HOME}/.msmtprc
whitelist ${HOME}/.mutt
whitelist ${HOME}/.muttrc
whitelist ${HOME}/.nanorc
whitelist ${HOME}/.signature
whitelist ${HOME}/.vim
whitelist ${HOME}/.viminfo
whitelist ${HOME}/.vimrc
whitelist ${HOME}/.w3m
whitelist ${HOME}/Mail
whitelist ${HOME}/mail
whitelist ${HOME}/postponed
whitelist ${HOME}/sent
whitelist /usr/share/gnupg
whitelist /usr/share/gnupg2
whitelist /usr/share/mutt
whitelist /var/mail
whitelist /var/spool/mail
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
