# Vivaldi browser profile
noblacklist ~/.config/vivaldi
noblacklist ~/.cache/vivaldi
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

netfilter

whitelist ${DOWNLOADS}
mkdir ~/.config/vivaldi
whitelist ~/.config/vivaldi
mkdir ~/.cache/vivaldi
whitelist ~/.cache/vivaldi
include /etc/firejail/whitelist-common.inc

# lastpass, keepassx
whitelist ~/.keepassx
whitelist ~/.config/keepassx
whitelist ~/keepassx.kdbx
whitelist ~/.lastpass
whitelist ~/.config/lastpass

