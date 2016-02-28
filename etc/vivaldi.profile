# Vivaldi browser profile
noblacklist ${HOME}/.config/vivaldi
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc

netfilter
whitelist ~/.config/vivaldi
whitelist ${DOWNLOADS}
whitelist ~/.cache/vivaldi
include /etc/firejail/whitelist-common.inc


