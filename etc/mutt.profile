# Firejail profile for mutt
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/mutt.local
# Persistent global definitions
include /etc/firejail/globals.local

blacklist /tmp/.X11-unix

noblacklist ~/.Mail
noblacklist ~/.bogofilter
noblacklist ~/.cache/mutt
noblacklist ~/.elinks
noblacklist ~/.emacs
noblacklist ~/.emacs.d
noblacklist ~/.gnupg
noblacklist ~/.mail
noblacklist ~/.mailcap
noblacklist ~/.msmtprc
noblacklist ~/.mutt
noblacklist ~/.mutt/muttrc
noblacklist ~/.muttrc
noblacklist ~/.signature
noblacklist ~/.vim
noblacklist ~/.viminfo
noblacklist ~/.vimrc
noblacklist ~/.w3m
noblacklist ~/Mail
noblacklist ~/mail
noblacklist ~/postponed
noblacklist ~/sent

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-programs.inc

caps.drop all
netfilter
no3d
nodvd
nogroups
nonewprivs
noroot
nosound
notv
novideo
protocol unix,inet,inet6
seccomp
shell none

private-dev
