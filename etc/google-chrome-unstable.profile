# Google Chrome unstable browser profile
noblacklist ${HOME}/.config/google-chrome-unstable
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc

# chromium is distributed with a perl script on Arch
# include /etc/firejail/disable-devel.inc
#

netfilter
whitelist ${DOWNLOADS}
whitelist ~/.config/google-chrome-unstable
whitelist ~/.cache/google-chrome-unstable
include /etc/firejail/whitelist-common.inc

