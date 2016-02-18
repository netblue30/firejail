# Opera-beta browser profile
noblacklist ${HOME}/.config/opera-beta
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-terminals.inc
netfilter
mkdir ~/.config
mkdir ~/.config/opera-beta
whitelist ~/.config/opera-beta
whitelist ${DOWNLOADS}
mkdir ~/.cache
mkdir ~/.cache/opera-beta
whitelist ~/.cache/opera-beta
mkdir ~/.pki
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc


