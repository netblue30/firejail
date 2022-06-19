# Firejail profile for neomutt
# Description: Mutt fork with advanced features and better documentation
# This file is overwritten after every install/update
quiet
# Persistent local customizations
include neomutt.local
# Persistent global definitions
include globals.local

noblacklist ${DOCUMENTS}
noblacklist ${HOME}/.Mail
noblacklist ${HOME}/.bogofilter
noblacklist ${HOME}/.config/mutt
noblacklist ${HOME}/.config/nano
noblacklist ${HOME}/.config/neomutt
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
noblacklist ${HOME}/.neomutt
noblacklist ${HOME}/.neomuttrc
noblacklist ${HOME}/.signature
noblacklist ${HOME}/.vim
noblacklist ${HOME}/.viminfo
noblacklist ${HOME}/.vimrc
noblacklist ${HOME}/.w3m
noblacklist ${HOME}/Mail
noblacklist ${HOME}/mail
noblacklist ${HOME}/postponed
noblacklist ${HOME}/sent
noblacklist /var/mail
noblacklist /var/spool/mail

blacklist /tmp/.X11-unix
blacklist ${RUNUSER}/wayland-*

include allow-lua.inc

include disable-common.inc
include disable-devel.inc
include disable-exec.inc
include disable-interpreters.inc
include disable-programs.inc
include disable-xdg.inc

mkdir ${HOME}/.Mail
mkdir ${HOME}/.bogofilter
mkdir ${HOME}/.config/mutt
mkdir ${HOME}/.config/nano
mkdir ${HOME}/.config/neomutt
mkdir ${HOME}/.elinks
mkdir ${HOME}/.emacs.d
mkdir ${HOME}/.gnupg
mkdir ${HOME}/.mail
mkdir ${HOME}/.mutt
mkdir ${HOME}/.neomutt
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
mkfile ${HOME}/.neomuttrc
mkfile ${HOME}/.signature
mkfile ${HOME}/.viminfo
mkfile ${HOME}/.vimrc
whitelist ${DOCUMENTS}
whitelist ${DOWNLOADS}
whitelist ${HOME}/.Mail
whitelist ${HOME}/.bogofilter
whitelist ${HOME}/.config/mutt
whitelist ${HOME}/.config/nano
whitelist ${HOME}/.config/neomutt
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
whitelist ${HOME}/.neomutt
whitelist ${HOME}/.neomuttrc
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
whitelist /usr/share/neomutt
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
tracelog

# disable-mnt
private-cache
private-dev
private-etc alternatives,ca-certificates,crypto-policies,dconf,fonts,gcrypt,gnupg,hostname,hosts,hosts.conf,ld.so.cache,ld.so.preload,mail,mailname,Mutt,Muttrc,Muttrc.d,neomuttrc,neomuttrc.d,nntpserver,nsswitch.conf,passwd,pki,resolv.conf,ssl,xdg
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
