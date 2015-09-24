# transmission-qt profile
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-history.inc
cblacklist ${HOME}/.pki/nssdb
blacklist {HOME}/.lastpass
blacklist {HOME}/.keepassx
blacklist {HOME}/.password-store
aps.drop all
seccomp
netfilter
noroot

