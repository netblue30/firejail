# Google Chrome beta browser profile
noblacklist ${HOME}/.config/google-chrome-beta
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-terminals.inc

# chromium is distributed with a perl script on Arch
# include /etc/firejail/disable-devel.inc
#

netfilter
whitelist ${DOWNLOADS}
mkdir ~/.config
mkdir ~/.config/google-chrome-beta
whitelist ~/.config/google-chrome-beta
mkdir ~/.cache
mkdir ~/.cache/google-chrome-beta
whitelist ~/.cache/google-chrome-beta
mkdir ~/.pki
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc

