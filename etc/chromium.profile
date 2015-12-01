# Chromium browser profile
noblacklist ${HOME}/.config/chromium
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc

# chromium is distributed with a perl script on Arch
# include /etc/firejail/disable-devel.inc
#

netfilter
whitelist ${DOWNLOADS}
whitelist ~/.config/chromium
whitelist ~/.cache/chromium
include /etc/firejail/whitelist-common.inc
