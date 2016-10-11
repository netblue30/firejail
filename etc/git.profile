# git profile

noblacklist ~/.gitconfig
noblacklist ~/.ssh
noblacklist ~/.gnupg
noblacklist ~/.emacs
noblacklist ~/.emacs.d
noblacklist ~/.viminfo
noblacklist ~/.vim

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-passwdmgr.inc

quiet

caps.drop all
netfilter
nonewprivs
noroot
nogroups
nosound
protocol unix,inet,inet6
seccomp
shell none

private-dev
