# Google Chrome browser profile
noblacklist ${HOME}/.config/google-chrome
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc

# chromium is distributed with a perl script on Arch
# include /etc/firejail/disable-devel.inc
#

netfilter
whitelist ${DOWNLOADS}
whitelist ~/.config/google-chrome
whitelist ~/.cache/google-chrome
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc
