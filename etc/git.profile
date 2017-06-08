quiet
# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/git.local

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
