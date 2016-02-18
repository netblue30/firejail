# Google Chrome browser profile
noblacklist ${HOME}/.config/google-chrome
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
mkdir ~/.config/google-chrome
whitelist ~/.config/google-chrome
mkdir ~/.cache
mkdir ~/.cache/google-chrome
whitelist ~/.cache/google-chrome
mkdir ~/.pki
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc
