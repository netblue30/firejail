# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/google-chrome.local

# Google Chrome browser profile
noblacklist ~/.config/google-chrome
noblacklist ~/.cache/google-chrome
noblacklist ~/.pki
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc

# chromium is distributed with a perl script on Arch
# include /etc/firejail/disable-devel.inc
#

caps.keep sys_chroot,sys_admin
netfilter

whitelist ${DOWNLOADS}
mkdir ~/.config/google-chrome
whitelist ~/.config/google-chrome
mkdir ~/.cache/google-chrome
whitelist ~/.cache/google-chrome
mkdir ~/.pki
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc

noexec ${HOME}
noexec /tmp
