# Opera browser profile
noblacklist ~/.config/opera
noblacklist ~/.cache/opera
noblacklist ~/keepassx.kdbx
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-terminals.inc

netfilter

whitelist ${DOWNLOADS}
mkdir ~/.config
mkdir ~/.config/opera
whitelist ~/.config/opera
mkdir ~/.cache
mkdir ~/.cache/opera
whitelist ~/.cache/opera
mkdir ~/.pki
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc

# lastpass, keepassx
whitelist ~/.keepassx
whitelist ~/.config/keepassx
whitelist ~/keepassx.kdbx
whitelist ~/.lastpass
whitelist ~/.config/lastpass

