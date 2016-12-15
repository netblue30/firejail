# Opera browser profile
noblacklist ~/.config/opera
noblacklist ~/.cache/opera
noblacklist ~/.opera
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

netfilter

whitelist ${DOWNLOADS}
mkdir ~/.config/opera
whitelist ~/.config/opera
mkdir ~/.cache/opera
whitelist ~/.cache/opera
mkdir ~/.opera
whitelist ~/.opera
mkdir ~/.pki
whitelist ~/.pki
include /etc/firejail/whitelist-common.inc

# lastpass, keepassx
whitelist ~/.keepassx
whitelist ~/.config/keepassx
whitelist ~/keepassx.kdbx
whitelist ~/.lastpass
whitelist ~/.config/lastpass

