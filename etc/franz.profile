# Franz profile
noblacklist ~/.config/Franz
noblacklist ~/.cache/Franz
include /etc/firejail/disable-common.inc
include /etc/firejail/disable-programs.inc
include /etc/firejail/disable-devel.inc

caps.drop all
seccomp
protocol unix,inet,inet6,netlink
netfilter
#tracelog
nonewprivs
noroot

whitelist ${DOWNLOADS}
mkdir ~/.config/Franz
whitelist ~/.config/Franz
mkdir ~/.cache/Franz
whitelist ~/.cache/Franz
mkdir ~/.pki
whitelist ~/.pki

include /etc/firejail/whitelist-common.inc
