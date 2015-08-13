# Midory browser profile
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc midori
include /etc/firejail/disable-history.inc
caps.drop all
seccomp
netfilter
noroot

