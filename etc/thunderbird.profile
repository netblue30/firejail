# Firejail profile for Mozilla Thunderbird (Icedove in Debian)
include /etc/firejail/disable-mgmt.inc
include /etc/firejail/disable-secret.inc
include /etc/firejail/disable-common.inc thunderbird icedove
caps.drop all
seccomp
netfilter
noroot

