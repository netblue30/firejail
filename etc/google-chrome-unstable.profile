# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/google-chrome-unstable.local

# Google Chrome unstable browser profile
noblacklist ~/.config/google-chrome-unstable
noblacklist ~/.cache/google-chrome-unstable
noblacklist ~/.pki
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc

# chromium is distributed with a perl script on Arch
# include /etc/firejail/disable-devel.inc
#

whitelist ${DOWNLOADS}
mkdir ~/.config/google-chrome-unstable
whitelist ~/.config/google-chrome-unstable
mkdir ~/.cache/google-chrome-unstable
whitelist ~/.cache/google-chrome-unstable
mkdir ~/.pki
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc

caps.keep sys_chroot,sys_admin
#ipc-namespace
netfilter
nogroups
shell none

private-dev
#private-tmp - problems with multiple browser sessions
#disable-mnt

noexec ${HOME}
noexec /tmp
