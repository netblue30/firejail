# Persistent global definitions go here
include /etc/firejail/globals.local

# This file is overwritten during software install.
# Persistent customizations should go in a .local file.
include /etc/firejail/flashpeak-slimjet.local

# SlimJet browser profile
# This is a whitelisted profile, the internal browser sandbox
# is disabled because it requires sudo password. The command
# to run it is as follows:
#
#  firejail flashpeak-slimjet --no-sandbox
#
noblacklist ~/.config/slimjet
noblacklist ~/.cache/slimjet
noblacklist ~/.pki
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc

# chromium is distributed with a perl script on Arch
# include /etc/firejail/disable-devel.inc
#

caps.drop all
netfilter
nonewprivs
noroot
protocol unix,inet,inet6,netlink
seccomp

whitelist ${DOWNLOADS}
mkdir ~/.config/slimjet
whitelist ~/.config/slimjet
mkdir ~/.cache/slimjet
whitelist ~/.cache/slimjet
mkdir ~/.pki
whitelist ~/.pki

include /etc/firejail/whitelist-common.inc
