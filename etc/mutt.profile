# Firejail profile for mutt
# Description: Text-based mailreader supporting MIME, GPG, PGP and threading
# This file is overwritten after every install/update
# Persistent local customizations
include mutt.local
# Persistent global definitions
include globals.local

noblacklist /var/mail
noblacklist /var/spool/mail
noblacklist ${HOME}/.Mail
noblacklist ${HOME}/.bogofilter
noblacklist ${HOME}/.cache/mutt
noblacklist ${HOME}/.config/nano
noblacklist ${HOME}/.elinks
noblacklist ${HOME}/.emacs
noblacklist ${HOME}/.emacs.d
noblacklist ${HOME}/.gnupg
noblacklist ${HOME}/.mail
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

include disable-common.inc
include disable-devel.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
include disable-programs.inc

caps.drop all
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
shell none

private-dev
#private-etc Muttrc,Muttrc.d,alternatives,ca-certificates,crypto-policies,dbus-1,hosts,host.conf,hostname,ld.so.cache,ld.so.preload,ld.so.conf,ld.so.conf.d,locale,locale.alias,locale.conf,localtime,machine-id,mime.types,nsswitch.conf,passwd,pki,protocols,resolv.conf,rpc,services,ssl,xdg
writable-run-user
