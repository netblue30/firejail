# FileZilla profile
noblacklist ${HOME}/.filezilla
noblacklist ${HOME}/.config/filezilla
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-history.inc
blacklist ${HOME}/.wine
caps.drop all
seccomp
noroot
netfilter


