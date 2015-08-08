# Firejail profile for Mozilla Firefox (Iceweasel in Debian)
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc .mozilla
caps.drop all
seccomp
netfilter
noroot

