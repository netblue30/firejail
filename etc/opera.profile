# Opera browser profile
noblacklist ${HOME}/.config/opera
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
netfilter
whitelist ~/.config/opera
whitelist ${DOWNLOADS}
whitelist ~/.cache/opera
include /etc/firejail/whitelist-common.inc


