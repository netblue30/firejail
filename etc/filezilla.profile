# FileZilla profile
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc .filezilla
caps.drop all
seccomp
noroot
netfilter


