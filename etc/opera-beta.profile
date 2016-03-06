# Opera-beta browser profile
noblacklist ~/.config/opera-beta
noblacklist ~/.cache/opera-beta
noblacklist ~/keepassx.kdbx
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-terminals.inc

netfilter

whitelist ${DOWNLOADS}
mkdir ~/.config
mkdir ~/.config/opera-beta
whitelist ~/.config/opera-beta
mkdir ~/.cache
mkdir ~/.cache/opera-beta
whitelist ~/.cache/opera-beta
mkdir ~/.pki
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc

# lastpass, keepassx
whitelist ~/.keepassx
whitelist ~/.config/keepassx
whitelist ~/keepassx.kdbx
whitelist ~/.lastpass
whitelist ~/.config/lastpass

