# Inox browser profile
noblacklist ~/.config/inox
noblacklist ~/.cache/inox
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc

netfilter

whitelist ${DOWNLOADS}
mkdir ~/.config/inox
whitelist ~/.config/inox
mkdir ~/.cache/inox
whitelist ~/.cache/inox
mkdir ~/.pki
whitelist ~/.pki

# lastpass, keepass
# for keepass we additionally need to whitelist our .kdbx password database
whitelist ~/.keepass
whitelist ~/.config/keepass
whitelist ~/.config/KeePass
whitelist ~/.lastpass
whitelist ~/.config/lastpass

include /etc/firejail/whitelist-common.inc
