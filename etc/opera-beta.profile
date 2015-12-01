# Opera-beta browser profile
noblacklist ${HOME}/.config/opera-beta
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
netfilter
whitelist ~/.config/opera-beta
whitelist ${DOWNLOADS}
whitelist ~/.cache/opera-beta
include /etc/firejail/whitelist-common.inc


