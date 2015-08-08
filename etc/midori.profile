# Midory browser profile
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc midori
caps.drop all
seccomp
netfilter
noroot

