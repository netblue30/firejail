# Audacious profile
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-history.inc
blacklist ${HOME}/.pki/nssdb
blacklist {HOME}/.lastpass
blacklist {HOME}/.keepassx
blacklist {HOME}/.password-store
caps.drop all
seccomp
noroot

