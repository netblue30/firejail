# mutt email client profile
noblacklist ~/.muttrc
noblacklist ~/.mutt
noblacklist ~/.mutt/muttrc
noblacklist ~/.mailcap
noblacklist ~/.gnupg
noblacklist ~/.mail
noblacklist ~/.Mail
noblacklist ~/mail
noblacklist ~/Mail
noblacklist ~/sent
noblacklist ~/postponed
noblacklist ~/.cache/mutt
noblacklist ~/.w3m
noblacklist ~/.elinks
noblacklist ~/.vim
noblacklist ~/.vimrc
noblacklist ~/.viminfo
noblacklist ~/.emacs
noblacklist ~/.emacs.d
noblacklist ~/.signature
noblacklist ~/.bogofilter
noblacklist ~/.msmtprc

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/disable-devel.inc

caps.drop all
netfilter
nogroups
nonewprivs
noroot
nosound
no3d
protocol unix,inet,inet6
seccomp
shell none

blacklist /tmp/.X11-unix

private-dev
