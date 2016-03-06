# Vivaldi browser profile
noblacklist ~/.config/vivaldi
noblacklist ~/.cache/vivaldi
noblacklist ~/keepassx.kdbx
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-devel.inc
include /etc/firejail/disable-terminals.inc

netfilter
tracelog

whitelist ${DOWNLOADS}
mkdir ~/.config
mkdir ~/.config/vivaldi
whitelist ~/.config/vivaldi
mkdir ~/.cache
mkdir ~/.cache/vivaldi
whitelist ~/.cache/vivaldi
include /etc/firejail/whitelist-common.inc

# lastpass, keepassx
whitelist ~/.keepassx
whitelist ~/.config/keepassx
whitelist ~/keepassx.kdbx
whitelist ~/.lastpass
whitelist ~/.config/lastpass

