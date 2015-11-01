# Chromium browser profile
noblacklist ${HOME}/.config/chromium
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
netfilter
whitelist ~/Downloads
whitelist ~/.config/chromium
