# Firejail profile for flashpeak-slimjet
# This file is overwritten after every install/update
# Persistent local customizations
include /etc/firejail/flashpeak-slimjet.local
# Persistent global definitions
include /etc/firejail/globals.local

noblacklist ~/.cache/slimjet
noblacklist ~/.config/slimjet
noblacklist ~/.pki

include /etc/firejail/disable-common.inc
# include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-programs.inc

mkdir ~/.cache/slimjet
mkdir ~/.config/slimjet
mkdir ~/.pki
whitelist ${DOWNLOADS}
whitelist ~/.cache/slimjet
whitelist ~/.config/slimjet
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp

# CLOBBERED COMMENTS
#  firejail flashpeak-slimjet --no-sandbox
# chromium is distributed with a perl script on Arch
# is disabled because it requires sudo password. The command
# to run it is as follows:
